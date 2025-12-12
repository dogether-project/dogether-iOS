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
        let filter: FilterTypes = (sortViewDatas.value.filter == filter) ? .all : filter
        sortViewDatas.update { $0.filter = filter }
        
        let filteredSections = filterSections()
        let status: CertificationListViewStatus = filteredSections.isEmpty ? .empty : .hasData
        
        certificationListViewDatas.update {
            $0.sections = filteredSections
            $0.viewStatus = status
        }
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
        
        let filteredSections = filterSections()
        let status: CertificationListViewStatus = filteredSections.isEmpty ? .empty : .hasData
        
        self.statsViewDatas.accept(statsViewDatas)
        self.certificationListViewDatas.update {
            $0.sections = filteredSections
            $0.isLastPage = certificationListViewDatas.isLastPage
            $0.currentPage = page
            $0.viewStatus = status
        }
    }
    
    private func filterSections() -> [SectionEntity] {
        if sortViewDatas.value.filter == .all { return certificationListViewDatas.value.sections }
        
        return certificationListViewDatas.value.sections.compactMap { section in
            let filteredCerts = section.todos.filter { cert in
                guard let type = FilterTypes(status: cert.status.rawValue) else { return false }
                return type == sortViewDatas.value.filter
            }
            return filteredCerts.isEmpty ? nil : SectionEntity(type: section.type, todos: filteredCerts)
        }
    }
}
