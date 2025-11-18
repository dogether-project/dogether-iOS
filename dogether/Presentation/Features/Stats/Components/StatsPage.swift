//
//  StatsPage.swift
//  dogether
//
//  Created by yujaehong on 11/18/25.
//

import UIKit

final class StatsPage: BasePage {
    weak var delegate: BottomSheetDelegate?
    
    let navigationHeader = NavigationHeader(title: "통계")
    
    private let emptyView = GroupEmptyView()
    
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    
    private let groupInfoView = StatsGroupInfoView()
    private let dailyAchievementBarView = DailyAchievementBarView()
    private let myRankView = MyRankView()
    private let statsSummaryView = StatsSummaryView()
    private let dosikImageView = UIImageView()
    private let dosikArmView = UIImageView()
    
    private(set) var currentStatsViewDatas: StatsViewDatas?
    
    override func configureView() {
        backgroundColor = .clear
        
        dosikImageView.image = .glassDosik
        dosikImageView.contentMode = .scaleAspectFit
        
        dosikArmView.image = .dosikArm
        dosikArmView.contentMode = .scaleAspectFit
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedGroupSelector))
        groupInfoView.groupSelectorStackView.addGestureRecognizer(tap)
        
        emptyView.createButtonTapHandler = { [weak self] in
            guard let self else { return }
            coordinatorDelegate?.coordinator?.pushViewController(GroupCreateViewController())
        }
    }
    
    override func configureHierarchy() {
        addSubview(navigationHeader)
        addSubview(emptyView)
        
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        [
            groupInfoView,
            dosikImageView,
            dosikArmView,
            dailyAchievementBarView,
            myRankView,
            statsSummaryView
        ].forEach { scrollContentView.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        groupInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(94)
        }
        
        dosikImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(23.7)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(100)
            $0.height.equalTo(126)
        }
        
        dosikArmView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(95.53)
            $0.trailing.equalToSuperview().inset(27.07)
            $0.width.equalTo(91.5)
            $0.height.equalTo(28.4)
        }
        
        dailyAchievementBarView.snp.makeConstraints {
            $0.top.equalTo(groupInfoView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(343)
        }
        
        myRankView.snp.makeConstraints {
            $0.top.equalTo(dailyAchievementBarView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(180)
            $0.bottom.equalToSuperview().inset(22)
        }
        
        statsSummaryView.snp.makeConstraints {
            $0.top.equalTo(dailyAchievementBarView.snp.bottom).offset(16)
            $0.leading.equalTo(myRankView.snp.trailing).offset(18)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(myRankView.snp.width)
            $0.height.equalTo(180)
            $0.bottom.equalToSuperview().inset(22)
        }
    }
    
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? StatsViewDatas {
            if currentStatsViewDatas != datas {
                currentStatsViewDatas = datas
                
                switch datas.status {
                case .empty:
                    showEmptyState()
                    
                case .hasData:
                    showStats(datas)
                }
            }
        }
    }
}

extension StatsPage {
    private func showEmptyState() {
        emptyView.isHidden = false
        scrollView.isHidden = true
    }
    
    private func showStats(_ datas: StatsViewDatas) {
        emptyView.isHidden = true
        scrollView.isHidden = false
        
        groupInfoView.configure(
            groupName: datas.groupName,
            currentMemberCount: datas.currentMemberCount,
            maximumMemberCount: datas.maxMemberCount,
            joinCode: datas.joinCode,
            endDate: datas.endDate
        )
        
        dailyAchievementBarView.configure(achievements: datas.dailyAchievements)
        
        myRankView.configure(
            count: datas.totalMembers,
            rank: datas.myRank
        )
        
        statsSummaryView.configure(
            certificatedCount: datas.certificatedCount,
            approvedCount: datas.approvedCount,
            rejectedCount: datas.rejectedCount
        )
    }
    
    @objc private func tappedGroupSelector() {
        delegate?.presentBottomSheet()
    }
}
