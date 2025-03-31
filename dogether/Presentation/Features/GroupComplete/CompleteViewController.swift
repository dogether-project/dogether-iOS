//
//  CompleteViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import UIKit
import SnapKit

final class CompleteViewController: BaseViewController {
    var viewModel = CompleteViewModel()
    
    private let firecrackerImageView = {
        let imageView = UIImageView()
        imageView.image = .firecracker
        return imageView
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let completeButton = DogetherButton(title: "홈으로 가기", status: .enabled)
    
    private var groupInfoView = UIView()
    
    private func joinCodeShareButton(joinCode: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 12
        
        let label = UILabel()
        label.text = joinCode
        label.textColor = .grey0
        label.font = Fonts.head1B
        label.isUserInteractionEnabled = false
        
        let imageView = UIImageView()
        imageView.image = .share.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey400
        imageView.isUserInteractionEnabled = false
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        [stackView].forEach { button.addSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        return button
    }
    private var joinCodeShareButton = UIButton()
    
    private let noticeView = {
        let imageView = UIImageView(image: .notice)
        
        let label = UILabel()
        label.text = "카카오톡, 문자 등을 통해 공유해보세요 !"
        label.textColor = .grey400
        label.font = Fonts.body2R
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        titleLabel.attributedText = NSAttributedString(
            string: viewModel.groupType.completeTitleText,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
        
        completeButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.setNavigationController(MainViewController())
            }, for: .touchUpInside
        )
        
        switch viewModel.groupType {
        case .join:
            // FIXME: API 수정 후 내용 반영
            groupInfoView = DogetherGroupInfo(
                groupName: viewModel.groupInfo.name,
                memberCount: 10,
                duration: GroupChallengeDurations(rawValue: viewModel.groupInfo.duration) ?? .threeDays,
                startAtString: "2025-01-01",
                endAtString: viewModel.groupInfo.endAt
            )
        case .create:
            joinCodeShareButton = joinCodeShareButton(joinCode: viewModel.joinCode)
            joinCodeShareButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    present(UIActivityViewController(activityItems: [viewModel.joinCode], applicationActivities: nil), animated: true)
                }, for: .touchUpInside
            )
        }
    }
    
    override func configureHierarchy() {
        [firecrackerImageView, titleLabel, completeButton].forEach { view.addSubview($0) }
        
        switch viewModel.groupType {
        case .join:
            [groupInfoView].forEach { view.addSubview($0) }
        case .create:
            [joinCodeShareButton, noticeView].forEach { view.addSubview($0) }
        }
    }
    
    override func configureConstraints() {
        firecrackerImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(68)
            $0.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(firecrackerImageView.snp.bottom).offset(20)
            $0.height.equalTo(72)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        switch viewModel.groupType {
        case .join:
            groupInfoView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(40)
                $0.horizontalEdges.equalToSuperview().inset(36)
                $0.height.equalTo(269)
            }
        case .create:
            joinCodeShareButton.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(68)
                $0.horizontalEdges.equalToSuperview().inset(36)
                $0.height.equalTo(75)
            }
            
            noticeView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(joinCodeShareButton.snp.bottom).offset(16)
            }
        }
    }
}
