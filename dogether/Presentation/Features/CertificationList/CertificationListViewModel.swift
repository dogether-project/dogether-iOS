//
//  CertificationListViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

protocol CertificationListViewModelDelegate: AnyObject {
    func didFetchSucceed()
    func didFetchFail(error: NetworkError)
}

final class CertificationListViewModel {
    
    private let useCase: CertificationListUseCase
    weak var delegate: CertificationListViewModelDelegate?
    
    private var rawSections: [CertificationSection] = []
    var sections: [CertificationSection] = []
    
    var viewStatus: CertificationListViewStatus = .empty
    
    var totalCertificatedCount: Int = 0
    var totalApprovedCount: Int = 0
    var totalRejectedCount: Int = 0
    private var currentPage: Int = 0
    var isLastPage: Bool = false
    
    var currentFilter: FilterTypes = .all {
        didSet {
            applyFilter()
        }
    }

    var selectedGroup: CertificationSortOption? = CertificationSortOption.allCases.first

    init() {
        let repository = DIManager.shared.getCertificationListRepository()
        self.useCase = CertificationListUseCase(repository: repository)
    }
}

extension CertificationListViewModel {
    func executeSort(option: CertificationSortOption) {
        currentPage = 0
        isLastPage = false
        
        Task {
            do {
                let result = try await useCase.fetchSortedList(option: option, page: currentPage)
                self.rawSections = result.sections
                
                self.totalCertificatedCount = result.stats.totalCertificatedCount
                self.totalApprovedCount = result.stats.totalApprovedCount
                self.totalRejectedCount = result.stats.totalRejectedCount
                self.isLastPage = !result.hasNext
                self.applyFilter()
                self.viewStatus = self.sections.isEmpty ? .empty : .hasData
                print("\(currentPage)번째 페이지 로드")
            } catch let error as NetworkError {
                delegate?.didFetchFail(error: error)
            }
        }
    }
    
    private func applyFilter() {
        sections = rawSections.compactMap { section in
            let filtered = section.certifications.filter { cert in
                guard let filterType = FilterTypes(status: cert.status) else { return false }
                return currentFilter == .all || currentFilter == filterType
            }
            
            return filtered.isEmpty ? nil : CertificationSection(type: section.type, certifications: filtered)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didFetchSucceed()
        }
    }
    
    func loadNextPage() {
        guard !isLastPage else { return }
        guard let option = selectedGroup else { return }
        currentPage += 1
        
        Task {
            do {
                let result = try await useCase.fetchSortedList(option: option, page: currentPage)
                self.rawSections.append(contentsOf: result.sections)
                
                self.totalCertificatedCount = result.stats.totalCertificatedCount
                self.totalApprovedCount = result.stats.totalApprovedCount
                self.totalRejectedCount = result.stats.totalRejectedCount
                
                self.isLastPage = !result.hasNext
                
                self.applyFilter()
                print("\(currentPage)번째 페이지 로드")
            } catch let error as NetworkError {
                delegate?.didFetchFail(error: error)
                currentPage -= 1
            }
        }
    }
}
