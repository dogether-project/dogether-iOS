//
//  MyDashboardViewController.swift
//  dogether
//
//  Created by 박지은 on 2/14/25.
//

import UIKit
import SnapKit

final class MyDashboardViewController: BaseViewController {
    
    private let messageLabel = {
        let label = UILabel()
        let myTodoMessage = "대단해요!\n총 123개의 투두를 달성했어요"
        let attributedText = NSMutableAttributedString(string: myTodoMessage)
        
        if let range = myTodoMessage.range(of: "123개") {
            let nsRagne = NSRange(range, in: myTodoMessage)
            attributedText.addAttribute(.foregroundColor, value: UIColor.blue300, range: nsRagne)
        }
        
        label.attributedText = attributedText
        label.font = Fonts.head1B
        label.textColor = .grey0
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyDashboardCollectionViewCell.self, forCellWithReuseIdentifier: "MyDashboardCollectionViewCell")
        return collectionView
    }()
    
    private let progressStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .orange
        stackView.layer.cornerRadius = 12
        
        return stackView
    }()
    
    private let progressTitleLabel = {
        let label = UILabel()
        label.text = "인증한 기간"
        label.font = Fonts.head2B
        label.textColor = .grey0
        return label
    }()
    
    private let progressYLabels = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .leading
        
        let yLabels = ["10", "8", "6", "4", "2", "0"]
        for text in yLabels {
            let label = UILabel()
            label.text = text
            label.font = Fonts.body2S
            label.textColor = .grey500
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()

    private func createProgressView(title: String, progress: Float) -> UIStackView {
        
        // 프로그레스바 전체
        let progressBarContainer = UIView()
        progressBarContainer.backgroundColor = .yellow
        progressBarContainer.layer.cornerRadius = 10

        // 프로그레스바 실행률
        let progressBar = UIView()
        progressBar.backgroundColor = .green
        progressBar.layer.cornerRadius = 8
 
        progressBarContainer.addSubview(progressBar)
        
        progressBarContainer.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(180)
        }

        progressBar.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(progress)
        }

        let label = UILabel()
        label.text = title
        label.font = Fonts.body2R
        
        let stackView = UIStackView(arrangedSubviews: [progressBarContainer, label])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        
        return stackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProgressBars()
    }
    
    override func configureHierarchy() {
        [messageLabel, collectionView, progressStackView].forEach {
            view.addSubview($0)
        }
        
        [progressTitleLabel, progressYLabels].forEach {
            progressStackView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(107)
        }
        
        progressStackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(343)
        }
        
        progressTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(44)
        }
        
        progressYLabels.snp.makeConstraints {
            $0.top.equalTo(progressTitleLabel.snp.bottom).offset(54)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(201)
        }

    }
    
    override func configureView() { }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 7
        let itemWidth = 107
        let itemHeight = 107
        
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
        
        // 프로그레스 바를 하나로 묶을 stackView
        let progressBarsContainer = UIStackView()
        progressBarsContainer.axis = .horizontal
        progressBarsContainer.spacing = 2
        progressBarsContainer.distribution = .equalSpacing
        
        for (title, progress) in progressData {
            let progressView = createProgressView(title: title, progress: Float(progress))
            
            progressView.layer.borderColor = UIColor.white.cgColor
            progressView.layer.borderWidth = 1
            
            progressBarsContainer.addArrangedSubview(progressView)
            
            progressView.snp.makeConstraints {
                $0.width.equalTo(50)
            }
        }
        
        progressStackView.addArrangedSubview(progressBarsContainer)
        
        progressBarsContainer.layer.borderColor = UIColor.purple.cgColor
        progressBarsContainer.layer.borderWidth = 1
        
        progressBarsContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(51)
            $0.trailing.equalToSuperview().offset(-32)
        }
    }
}

extension MyDashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyDashboardCollectionViewCell", for: indexPath)
        
        let items = [
            (image: UIImage(), title: "달성 개수", count: "123개"),
            (image: UIImage(), title: "인정 개수", count: "123개"),
            (image: UIImage(), title: "노인정 개수", count: "123개")
        ]
        
        let item = items[indexPath.row]
        
        cell.backgroundColor = .grey700
        cell.layer.cornerRadius = 12
        
        return cell
    }
}
