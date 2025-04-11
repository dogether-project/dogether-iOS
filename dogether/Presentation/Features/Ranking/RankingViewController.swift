//
//  RankingViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit
import SnapKit

final class RankingViewController: BaseViewController {
    var rankings: [RankingModel]?
    
    private let navigationHeader = NavigationHeader(title: "순위")
    
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
        
        let imageView = UIImageView(image: .notice)
        
        let label = UILabel()
        label.text = "달성률은 작성한 투두 중 완료한 비율을 의미합니다."
        label.textColor = .grey400
        label.font = Fonts.body2S
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        [stackView].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        return view
    }()
    
    private let rankingTableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        guard let rankings else { return }
        let rankingTopViews = (0 ..< 3).map { RankingTopView(ranking: rankings.count > $0 ? rankings[$0] : nil) }
        rankingTopStackView = rankingTopStackView(views: [rankingTopViews[1], rankingTopViews[0], rankingTopViews[2]])
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        rankingTableView.register(RankingTableViewCell.self, forCellReuseIdentifier: RankingTableViewCell.identifier)
    }
    
    override func configureHierarchy() {
        [navigationHeader, rankingTopStackView, descriptionView, rankingTableView].forEach { view.addSubview($0) }
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
        
        rankingTableView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(18)
            $0.bottom.left.right.equalToSuperview()
        }
    }
}

// MARK: - aboout tableView
extension RankingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rankings, rankings.count > 3 else { return 0}
        return rankings.count - 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ranking = rankings?[indexPath.row + 3], let cell = tableView.dequeueReusableCell(
            withIdentifier: RankingTableViewCell.identifier,
            for: indexPath
        ) as? RankingTableViewCell else { return UITableViewCell() }
        
        cell.setExtraInfo(ranking: ranking)
        
        return cell
    }
}
