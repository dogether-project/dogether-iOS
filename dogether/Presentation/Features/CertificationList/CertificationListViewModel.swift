//
//  CertificationListViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import Foundation
import RxRelay

final class CertificationListViewModel {
    private let useCase: CertificationListUseCase
    
    private(set) var bottomSheetViewDatas = BehaviorRelay<BottomSheetViewDatas>(value: BottomSheetViewDatas())
    private(set) var sortSheetDatas = BehaviorRelay<CertificationSortSheetDatas>(
        value: CertificationSortSheetDatas()
    )
    private(set) var certificationListViewDatas =
        BehaviorRelay<CertificationListViewDatas>(value: CertificationListViewDatas())
    
    private var rawSections: [CertificationSection] = []
    
    init() {
        let repository = DIManager.shared.getCertificationListRepository()
        self.useCase = CertificationListUseCase(repository: repository)
    }
}

extension CertificationListViewModel {
    func executeSort(option: CertificationSortOption) async throws {
        sortSheetDatas.update { $0.selected = option }
        
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
        
        let filteredSections = filterSections(source: rawSections, filter: newFilter)
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
    private func fetchSortedList(
        option: CertificationSortOption,
        page: Int,
        isReset: Bool
    ) async throws {
        let result = try await useCase.fetchSortedList(option: option, page: page)
        
        if isReset {
            rawSections = result.sections
        } else {
            rawSections.append(contentsOf: result.sections)
        }
        
        let filter = certificationListViewDatas.value.currentFilter
        let filteredSections = filterSections(source: rawSections, filter: filter)
        let status: CertificationListViewStatus = filteredSections.isEmpty ? .empty : .hasData
        
        certificationListViewDatas.update {
            $0.sections = filteredSections
            $0.totalCertificatedCount = result.stats.totalCertificatedCount
            $0.totalApprovedCount = result.stats.totalApprovedCount
            $0.totalRejectedCount = result.stats.totalRejectedCount
            $0.isLastPage = !result.hasNext
            $0.currentPage = page
            $0.viewStatus = status
        }
    }
    
    private func filterSections(
        source: [CertificationSection],
        filter: FilterTypes
    ) -> [CertificationSection] {
        guard filter != .all else { return source }
        
        return source.compactMap { section in
            let filteredCerts = section.certifications.filter { cert in
                guard let type = FilterTypes(status: cert.status) else { return false }
                return type == filter
            }
            return filteredCerts.isEmpty ? nil : CertificationSection(
                type: section.type,
                certifications: filteredCerts
            )
        }
    }
}
