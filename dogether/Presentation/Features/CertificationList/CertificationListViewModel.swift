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
    private(set) var sortViewDatas = BehaviorRelay<SortViewDatas>(value: SortViewDatas())
    private(set) var statsViewDatas = BehaviorRelay<StatsViewDatas>(value: StatsViewDatas())
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
        // FIXME: sort list fetch 작업 추가 예정
        sortViewDatas.update { $0.index = index }
    }
}

extension CertificationListViewModel {
    func executeSort(option: SortOptions) async throws {
        certificationListViewDatas.update {
            $0.selectedSortOption = option
            $0.currentPage = 0
            $0.isLastPage = false
        }
        
        try await fetchSortedList(option: option, page: 0, isReset: true)
    }
    
    func changeFilter(_ filter: FilterTypes) {
        let currentFilter = certificationListViewDatas.value.currentFilter
        let newFilter: FilterTypes = (currentFilter == filter) ? .all : filter
        
        let filteredSections = filterSections(filter: newFilter)
        let status: CertificationListViewStatus = filteredSections.isEmpty ? .empty : .hasData
        
        certificationListViewDatas.update {
            $0.currentFilter = newFilter
            $0.sections = filteredSections
            $0.viewStatus = status
        }
    }
    
    func loadNextPage() async throws {
        let datas = certificationListViewDatas.value
        guard !datas.isLastPage else { return }
        
        let nextPage = datas.currentPage + 1
        let option = datas.selectedSortOption
        
        try await fetchSortedList(option: option, page: nextPage, isReset: false)
    }
}

extension CertificationListViewModel {
    private func fetchSortedList(option: SortOptions, page: Int, isReset: Bool) async throws {
        let (statsViewDatas, certificationListViewDatas) = try await userUseCase.getCertificationListViewDatas(option: option, page: page)
        
        if isReset {
            self.certificationListViewDatas.update { $0.sections = certificationListViewDatas.sections }
        } else {
            self.certificationListViewDatas.update {
                $0.sections = $0.sections + certificationListViewDatas.sections
            }
        }
        
        let filter = self.certificationListViewDatas.value.currentFilter
        let filteredSections = filterSections(filter: filter)
        let status: CertificationListViewStatus = filteredSections.isEmpty ? .empty : .hasData
        
        self.statsViewDatas.accept(statsViewDatas)
        self.certificationListViewDatas.update {
            $0.sections = filteredSections
            $0.isLastPage = certificationListViewDatas.isLastPage
            $0.currentPage = page
            $0.viewStatus = status
        }
    }
    
    private func filterSections(filter: FilterTypes) -> [SectionEntity] {
        if filter == .all { return certificationListViewDatas.value.sections }
        
        return certificationListViewDatas.value.sections.compactMap { section in
            let filteredCerts = section.todos.filter { cert in
                guard let type = FilterTypes(status: cert.status.rawValue) else { return false }
                return type == filter
            }
            return filteredCerts.isEmpty ? nil : SectionEntity(type: section.type, todos: filteredCerts)
        }
    }
}
