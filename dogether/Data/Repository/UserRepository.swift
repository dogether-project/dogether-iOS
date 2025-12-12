//
//  UserRepository.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

final class UserRepository: UserProtocol {
    private let userDataSource: UserDataSource
    
    init(userDataSource: UserDataSource = .shared) {
        self.userDataSource = userDataSource
    }
    
    func getStatsViewDatas(groupId: Int) async throws -> (
        achievementViewDatas: AchievementViewDatas,
        rankViewDatas: StatsRankViewDatas,
        summaryViewDatas: StatsSummaryViewDatas
    ) {
        let response = try await userDataSource.getMyGroupActivity(groupId: groupId)
        
        let achievementViewDatas = AchievementViewDatas(
            achievements: response.certificationPeriods.map {
                AchievementEntity(
                    day: $0.day,
                    createdCount: $0.createdCount,
                    certificationRate: $0.certificationRate
                )
            }
        )
        
        let rankViewDatas = StatsRankViewDatas(
            totalMembers: response.ranking.totalMemberCount,
            myRank: response.ranking.myRank
        )
        
        let summaryViewDatas = StatsSummaryViewDatas(
            certificatedCount: response.stats.certificatedCount,
            approvedCount: response.stats.approvedCount,
            rejectedCount: response.stats.rejectedCount
        )
        
        return (achievementViewDatas, rankViewDatas, summaryViewDatas)
    }
    
    func getCertificationList(option: SortOptions, page: Int) async throws -> (
        statsViewDatas: StatsViewDatas,
        certificationListViewDatas: CertificationListViewDatas
    ) {
        let response = try await userDataSource.getMyActivity(sort: option.sortString, page: String(page))
        
        let statsViewDatas = StatsViewDatas(
            achievementCount: response.dailyTodoStats.totalCertificatedCount,
            approveCount: response.dailyTodoStats.totalApprovedCount,
            rejectCount: response.dailyTodoStats.totalRejectedCount
        )
        
        let sections: [SectionEntity]
        if let certificationsGroupedByTodoCompletedAt = response.certificationsGroupedByTodoCompletedAt {
            let todos: [TodoEntity] = certificationsGroupedByTodoCompletedAt.flatMap { daily in
                daily.certificationInfo.map { info in
                    TodoEntity(
                        id: info.id,
                        content: info.content,
                        status: TodoStatus(rawValue: info.status) ?? .waitCertification,
                        certificationContent: info.certificationContent,
                        certificationMediaUrl: info.certificationMediaUrl,
                        reviewFeedback: info.reviewFeedback,
                        createdAt: daily.createdAt
                    )
                }
            }
            
            // ???: 직접 sort를 해주는 이유가 있나요?
            let grouped = Dictionary(grouping: todos, by: { $0.createdAt ?? "" })
            
            sections = grouped.keys.sorted(by: >).map { date in
                SectionEntity(
                    type: .daily(dateString: date),
                    todos: grouped[date] ?? []
                )
            }
        } else if let certificationsGroupedByGroupCreatedAt = response.certificationsGroupedByGroupCreatedAt {
            sections = certificationsGroupedByGroupCreatedAt.map { group in
                let todos = group.certificationInfo.map { info in
                    TodoEntity(
                        id: info.id,
                        content: info.content,
                        status: TodoStatus(rawValue: info.status) ?? .waitCertification,
                        certificationContent: info.certificationContent,
                        certificationMediaUrl: info.certificationMediaUrl,
                        reviewFeedback: info.reviewFeedback
                    )
                }
                
                return SectionEntity(type: .group(groupName: group.groupName), todos: todos)
            }
        } else { sections = [] }
        
        let certificationListViewDatas = CertificationListViewDatas(
            sections: sections,
            isLastPage: !response.pageInfo.hasNext
        )
        
        return (statsViewDatas, certificationListViewDatas)
    }
    
    func getProfileViewDatas() async throws -> ProfileViewDatas {
        let response = try await userDataSource.getMyProfile()
        return ProfileViewDatas(
            name: response.name,
            imageUrl: response.profileImageUrl
        )
    }
}
