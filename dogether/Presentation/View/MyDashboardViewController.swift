//
//  MyDashboardViewController.swift
//  dogether
//
//  Created by 박지은 on 2/14/25.
//

import UIKit
import SnapKit

final class MyDashboardViewController: BaseViewController {
    
    private let progressStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .grey700
        stackView.layer.cornerRadius = 12
        return stackView
    }()
    
    private let messageLabel = {
        let label = UILabel()
        label.text = "대단해요!\n목표까지 얼마 남지 않았어요"
        label.font = Fonts.head2B
        label.textColor = .grey0
        label.numberOfLines = 0
        return label
    }()
    
    private func createProgressView(title: String, progress: Float) -> UIStackView {
        
        let progressBarContainer = UIView()
        progressBarContainer.backgroundColor = .yellow
        progressBarContainer.layer.cornerRadius = 10
        
        let progressBar = UIView()
        progressBar.backgroundColor = .green
        progressBar.layer.cornerRadius = 8
        progressBarContainer.addSubview(progressBar)
        
        progressBar.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(progress)
        }
        
        let label = UILabel()
        label.text = title
        label.font = Fonts.body2R
        
        let stackView = UIStackView(arrangedSubviews: [progressBarContainer, label])
        stackView.axis = .vertical
        stackView.spacing = 6
        
        progressBarContainer.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(120)
        }
        return stackView
    }
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyDashboardCollectionViewCell.self, forCellWithReuseIdentifier: "MyDashboardCollectionViewCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProgressBars()
    }
    
    override func configureHierarchy() {
        [progressStackView, messageLabel, collectionView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(44)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        progressStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(341)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(progressStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(152)
        }
    }
    
    override func configureView() { }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 7
        let itemWidth = 168
        let itemHeight = 72
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = spacing
        
        return layout
    }
    
    private func configureProgressBars() {
        let progressData = [
            ("1일차", 0.2),
            ("2일차", 0.5),
            ("3일차", 0.7),
            ("4일차", 1.0)
        ]
        
        for (title, progress) in progressData {
            let progressView = createProgressView(title: title, progress: Float(progress))
            progressStackView.addArrangedSubview(progressView)
            
        }
    }
}

extension MyDashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyDashboardCollectionViewCell", for: indexPath)
        cell.backgroundColor = .grey700
        cell.layer.cornerRadius = 12
        return cell
    }
}
