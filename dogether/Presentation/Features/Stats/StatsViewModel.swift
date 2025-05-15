//
//  StatsViewModel.swift
//  dogether
//
//  Created by yujaehong on 4/22/25.
//

import Foundation

enum StatsViewStatus {
    case empty
    case hasData
}

protocol StatsViewModelDelegate: AnyObject {
    func didFetchStatsSucceed()
}

struct GroupSortOption: BottomSheetItemRepresentable, Hashable {
    let groupId: Int
    let groupName: String
    
    var displayName: String {
        return groupName
    }
    
    var bottomSheetItem: BottomSheetItem {
        BottomSheetItem(displayName: displayName, value: self)
    }
}

final class StatsViewModel {
    
    private let statsUseCase: StatsUseCase
    private let groupUseCase: GroupUseCase
    
    weak var delegate: StatsViewModelDelegate?
    
    var statsViewStatus: StatsViewStatus = .empty
    
    var groupName: String = ""
    var endDate: String = ""
    var maximumMemberCount: Int = 0
    var currentMemberCount: Int = 0
    var joinCode: String = ""
    
    var dailyAchievements: [CertificationPeriod] = []
    var myRank: Int = 0
    var totalMembers: Int = 0
    var statsSummary: Stats?
    
    var myGroups: [ChallengeGroup] = [] // 받아온 그룹 아이디를 통해 특정 그룹 활동 통계 조회
    var groupSortOptions: [GroupSortOption] = []
    
    init() {
        let statsrepository = DIManager.shared.getStatsRepository()
        let groupRepository = DIManager.shared.getGroupRepository()
        self.statsUseCase = StatsUseCase(repository: statsrepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension StatsViewModel {
    private func fetchStats(groupId: Int) {
        Task {
            do {
                let response = try await statsUseCase.fetchGroupStats(groupId: groupId)
                apply(response: response)
                delegate?.didFetchStatsSucceed()
            } catch {
                statsViewStatus = .empty
                throw error
            }
        }
    }
    
    private func apply(response: GroupStatsResponse) {
        let data = response
        statsViewStatus = .hasData
        groupName = data.groupInfo.name
        endDate = data.groupInfo.endAt
        maximumMemberCount = data.groupInfo.maximumMemberCount
        currentMemberCount = data.groupInfo.currentMemberCount
        joinCode = data.groupInfo.joinCode
        
        myRank = data.ranking.myRank
        totalMembers = data.ranking.totalMemberCount
        statsSummary = data.stats
        dailyAchievements = data.certificationPeriods
    }
    
    func fetchMyGroups() {
        Task {
            do {
                let response = try await groupUseCase.getMyGroup()
                let challengeGroups = response.joiningChallengeGroups
                self.myGroups = challengeGroups // 참여중인 그룹 목록 저장
                
                // GroupSortOption 배열로 변환
                self.groupSortOptions = challengeGroups.map {
                    GroupSortOption(groupId: $0.groupId, groupName: $0.groupName)
                }
                
                if let firstGroup = challengeGroups.first {
                    fetchStats(groupId: firstGroup.groupId)
                } else {
                    statsViewStatus = .empty
                }
            } catch {
                statsViewStatus = .empty
            }
        }
    }
    
    func fetchStatsForSelectedGroup(_ option: GroupSortOption) {
        fetchStats(groupId: option.groupId)
    }
}
