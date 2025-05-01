//
//  StatsContentView.swift
//  dogether
//
//  Created by yujaehong on 4/23/25.
//

import UIKit

final class StatsContentView: BaseView {
    var viewModel: StatsViewModel
    
    private let groupInfoView = GroupInfoView()
    private lazy var dailyAchievementBarView = DailyAchievementBarView(viewModel: viewModel)
    private lazy var myRankView = MyRankView(viewModel: viewModel)
    private lazy var statsSummaryView = StatsSummaryView(viewModel: viewModel)
    
    private let mascotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "glassDusik")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false // 겹침 허용
        return imageView
    }()
    
    init(viewModel: StatsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func configureView() {
        backgroundColor = .clear
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        addSubview(groupInfoView)
        addSubview(mascotImageView)
        addSubview(dailyAchievementBarView)
        addSubview(myRankView)
        addSubview(statsSummaryView)
    }
    
    override func configureConstraints() {
        groupInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(97)
        }
        
        mascotImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(120)
            $0.trailing.equalToSuperview().inset(24) // 수정 필요
            $0.top.equalToSuperview().inset(70)
        }

        
        dailyAchievementBarView.snp.makeConstraints {
            $0.top.equalTo(groupInfoView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(343)
        }

        myRankView.snp.makeConstraints {
            $0.top.equalTo(dailyAchievementBarView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(163)
            $0.height.equalTo(180)
        }

        statsSummaryView.snp.makeConstraints {
            $0.top.equalTo(dailyAchievementBarView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(163)
            $0.height.equalTo(180)
            $0.leading.equalTo(myRankView.snp.trailing).offset(17)
        }
    }
}

extension StatsContentView {
//    groupInfoView.setGroupInfo(groupInfo: viewModel.)
}
