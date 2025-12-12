//
//  CertificationListViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import RxRelay

final class CertificationListViewModel {
    private let userUseCase: UserUseCase
    
    private(set) var bottomSheetViewDatas = BehaviorRelay<BottomSheetViewDatas>(value: BottomSheetViewDatas())
    private(set) var statsViewDatas = BehaviorRelay<StatsViewDatas>(value: StatsViewDatas())
    private(set) var sortViewDatas = BehaviorRelay<SortViewDatas>(value: SortViewDatas())
    private(set) var certificationListViewDatas = BehaviorRelay<CertificationListViewDatas>(
        value: CertificationListViewDatas()
    )
    
    init() {
        let repository = DIManager.shared.getUserRepository()
        self.userUseCase = UserUseCase(repository: repository)
    }
}

extension CertificationListViewModel {
    func updateSortIndex(index: Int) {
        sortViewDatas.update { $0.index = index }
    }
}

extension CertificationListViewModel {
    func executeSort() async throws {
        certificationListViewDatas.update {
            $0.currentPage = 0
            $0.isLastPage = false
        }
        
        try await fetchSortedList(page: 0, isReset: true)
    }
    
    func updateFilter(filter: FilterTypes) {
        let filter: FilterTypes = (certificationListViewDatas.value.filter == filter) ? .all : filter
        certificationListViewDatas.update { $0.filter = filter }
    }
    
    func loadNextPage() async throws {
        if certificationListViewDatas.value.isLastPage { return }
        
        try await fetchSortedList(page: certificationListViewDatas.value.currentPage + 1, isReset: false)
    }
}

extension CertificationListViewModel {
    private func fetchSortedList(page: Int, isReset: Bool) async throws {
        let (statsViewDatas, certificationListViewDatas) = try await userUseCase.getCertificationListViewDatas(
            option: sortViewDatas.value.options[sortViewDatas.value.index],
            page: page
        )
        
        if isReset {
            self.certificationListViewDatas.update { $0.sections = certificationListViewDatas.sections }
        } else {
            self.certificationListViewDatas.update {
                $0.sections = $0.sections + certificationListViewDatas.sections
            }
        }
        
        self.statsViewDatas.accept(statsViewDatas)
        self.certificationListViewDatas.update {
            $0.isLastPage = certificationListViewDatas.isLastPage
            $0.currentPage = page
        }
    }
}
