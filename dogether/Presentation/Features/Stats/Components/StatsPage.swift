//
//  StatsPage.swift
//  dogether
//
//  Created by yujaehong on 11/18/25.
//

import UIKit

final class StatsPage: BasePage {
    var delegate: StatsDelegate? {
        didSet {
            bottomSheetView.statsDelegate = delegate
            
            groupInfoView.statsDelegate = delegate
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "통계")
    
    private let emptyView = GroupEmptyView()
    
    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    
    private let groupInfoView = GroupInfoView(type: .stats)
    private let dailyAchievementBarView = DailyAchievementBarView()
    private let myRankView = MyRankView()
    private let statsSummaryView = StatsSummaryView()
    private let dosikImageView = UIImageView()
    private let dosikArmView = UIImageView()
    
    private let bottomSheetView = BottomSheetView(hasAddButton: false)
    
//    private var errorView: ErrorView?
    
    override func configureView() {
        backgroundColor = .clear
        
        dosikImageView.image = .glassDosik
        dosikImageView.contentMode = .scaleAspectFit
        
        dosikArmView.image = .dosikArm
        dosikArmView.contentMode = .scaleAspectFit
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedGroupSelector))
//        groupInfoView.groupSelectorStackView.addGestureRecognizer(tap)
        
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
        
        [ groupInfoView, dosikImageView, dosikArmView,
          dailyAchievementBarView, myRankView, statsSummaryView
        ].forEach { scrollContentView.addSubview($0) }
        
        addSubview(bottomSheetView)
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
            $0.top.equalTo(groupInfoView.snp.bottom).offset(15)
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
        
        bottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? BottomSheetViewDatas {
            bottomSheetView.updateView(datas)
        }
        
        if let datas = data as? StatsPageViewDatas {
            switch datas.status {
            case .empty:
                emptyView.isHidden = false
                scrollView.isHidden = true
                
            case .hasData:
                emptyView.isHidden = true
                scrollView.isHidden = false
            }
        }
        
        if let datas = data as? GroupViewDatas, datas.groups.count > 0 {
            bottomSheetView.updateView(datas)
            groupInfoView.updateView(datas.groups[datas.index])
        }
        
        if let datas = data as? DailyAchievementBarViewDatas {
            dailyAchievementBarView.updateView(datas)
        }
        
        if let datas = data as? MyRankViewDatas {
            myRankView.updateView(datas)
        }
        
        if let datas = data as? StatsSummaryViewDatas {
            statsSummaryView.updateView(datas)
        }
    }
}
