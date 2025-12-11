//
//  UserRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

final class UserRepositoryTest: UserProtocol {
    private let userDataSource: UserDataSource
    
    init(userDataSource: UserDataSource = .shared) {
        self.userDataSource = userDataSource
    }
    
    func getStatsViewDatas(groupId: Int) async throws -> (
        achievementViewDatas: AchievementViewDatas,
        rankViewDatas: StatsRankViewDatas,
        summaryViewDatas: StatsSummaryViewDatas
    ) {
        guard let url = Bundle.main.url(forResource: "StatsMock", withExtension: "json") else {
           throw URLError(.fileDoesNotExist)
       }
       let data = try Data(contentsOf: url)
       let response = try JSONDecoder().decode(GetMyGroupActivityResponse.self, from: data)
        
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
        if option == .todoCompletionDate {
            return try await getCertificationListSortByDate(sort: option.sortString, page: String(page))
        } else {
            // MARK: option == .groupCreationDate
            return try await getCertificationListSortByGroup(sort: option.sortString, page: String(page))
        }
    }
    
    func getProfileViewDatas() async throws -> ProfileViewDatas {
        return ProfileViewDatas(name: "두식", imageUrl: "")
    }
}

// MARK: getCertificationList
extension UserRepositoryTest {
    private func getCertificationListSortByDate(sort: String, page: String) async throws -> (
        statsViewDatas: StatsViewDatas,
        certificationListViewDatas: CertificationListViewDatas
    ) {
        let filename = "TodoCompletedDatePage\(page)Mock"
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "파일 없음", code: 404)
        }

        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(GetMyActivityResponse.self, from: data)
        
        let statsViewDatas = StatsViewDatas(
            achievementCount: response.dailyTodoStats.totalCertificatedCount,
            approveCount: response.dailyTodoStats.totalApprovedCount,
            rejectCount: response.dailyTodoStats.totalRejectedCount
        )
        
        let todos: [TodoEntity] = response.certificationsGroupedByTodoCompletedAt?.flatMap { daily in
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
        } ?? []
        
        let grouped = Dictionary(grouping: todos, by: { $0.createdAt ?? "" })
        
        let sections: [SectionEntity] = grouped.keys.sorted(by: >).map { date in
            SectionEntity(type: .daily(dateString: date), todos: grouped[date] ?? [])
        }
        
        let certificationListViewDatas = CertificationListViewDatas(
            sections: sections,
            isLastPage: !response.pageInfo.hasNext
        )
        
        return (statsViewDatas, certificationListViewDatas)
    }
     
    private func getCertificationListSortByGroup(sort: String, page: String) async throws -> (
        statsViewDatas: StatsViewDatas,
        certificationListViewDatas: CertificationListViewDatas
    ) {
        let filename = "GroupCreatedDatePage\(page)Mock"
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "파일 없음", code: 404)
        }

        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(GetMyActivityResponse.self, from: data)
        
        let statsViewDatas = StatsViewDatas(
            achievementCount: response.dailyTodoStats.totalCertificatedCount,
            approveCount: response.dailyTodoStats.totalApprovedCount,
            rejectCount: response.dailyTodoStats.totalRejectedCount
        )
        
        let sections: [SectionEntity] = response.certificationsGroupedByGroupCreatedAt?.map { group in
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
            
            return SectionEntity(
                type: .group(groupName: group.groupName),
                todos: todos
            )
        } ?? []
        
        let certificationListViewDatas = CertificationListViewDatas(
            sections: sections,
            isLastPage: !response.pageInfo.hasNext
        )
        
        return (statsViewDatas, certificationListViewDatas)
    }
}
