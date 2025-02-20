//
//  RankingViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import Foundation
import UIKit
import SnapKit

final class RankingViewController: BaseViewController {
    private let viewModel = RankingViewModel()
    
    private let navigationHeader = NavigationHeader(title: "순위")
    private var ranking1View = UIView()
    private var ranking2View = UIView()
    private var ranking3View = UIView()
    private func rankingTopStackView(views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = 11
        stackView.distribution = .fillEqually
        return stackView
    }
    private var rankingTopStackView = UIStackView()
    private let descriptionView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.grey600.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    private let descriptionImageView = {
        let imageView = UIImageView()
        imageView.image = .notice
        return imageView
    }()
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "달성률은 작성한 투두 중 완료한 비율을 의미합니다."
        label.textColor = .grey400
        label.font = Fonts.body2S
        return label
    }()
    private func descriptionStackView(views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }
    private var descriptionStackView = UIStackView()
    private func rankingStackView(views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }
    private var rankingStackView = UIStackView()
    
    override func viewDidLoad() {
        Task { @MainActor in
            do {
                try await viewModel.getTeamSummary()
            } catch {
                // TODO: API 실패 시 처리에 대해 추후 논의
            }
            
            super.viewDidLoad()
        }
    }
    
    override func configureView() {
        ranking1View = RankingTopView(ranking: viewModel.ranking.count > 0 ? viewModel.ranking[0] : nil)
        ranking2View = RankingTopView(ranking: viewModel.ranking.count > 1 ? viewModel.ranking[1] : nil)
        ranking3View = RankingTopView(ranking: viewModel.ranking.count > 2 ? viewModel.ranking[2] : nil)
        rankingTopStackView = rankingTopStackView(views: [ranking2View, ranking1View, ranking3View])
        descriptionStackView = descriptionStackView(views: [descriptionImageView, descriptionLabel])
        rankingStackView = rankingStackView(
            views: viewModel.ranking
                .filter { $0.rank > 3 }
                .map { RankingView(ranking: $0) }
        )
    }
    
    override func configureHierarchy() {
        [navigationHeader, rankingTopStackView, descriptionView, descriptionStackView, rankingStackView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        }
        
        rankingTopStackView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(190)
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(rankingTopStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        descriptionImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        descriptionStackView.snp.makeConstraints {
            $0.center.equalTo(descriptionView)
        }
        
        rankingStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(32)
        }
    }
}
