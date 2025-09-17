//
//  GroupInfoView.swift
//  dogether
//
//  Created by seungyooooong on 3/8/25.
//

import UIKit

final class GroupInfoView: BaseView {
    var delegate: MainDelegate?
    
    private let hasCopyImage: Bool
    private(set) var challengeGroupInfo: ChallengeGroupInfo
    
    init(challengeGroupInfo: ChallengeGroupInfo = ChallengeGroupInfo(), hasCopyImage: Bool = true) {
        self.challengeGroupInfo = challengeGroupInfo
        self.hasCopyImage = hasCopyImage
        
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let dosikImageView = UIImageView(image: .noteDosik)
    
    private let nameLabel = UILabel()
    private let changeGroupImageView = UIImageView(image: .chevronDown)
    
    private let groupNameStackView = UIStackView()
    
    private let memberInfoLabel = UILabel()
    private let joinCodeInfoLabel = UILabel()
    private let endDateInfoLabel = UILabel()
    
    private let joinCodeCopyImageView = UIImageView(image: .copy)
    private let joinCodeInfoStackView = UIStackView()
    
    private var memberStackView = UIStackView()
    private var joinCodeStackView = UIStackView()
    private var endDateStackView = UIStackView()
    
    let groupInfoStackView = UIStackView()
    
    // TODO: 추후 Label 전체 개선 시 다른 descriptionLabel들과 통일하도록 수정
    private let durationDescriptionLabel = UILabel()
    private let durationInfoLabel = UILabel()
    private let durationProgressView = UIProgressView()
    
    let durationStackView = UIStackView()
    
    override func configureView() {
        nameLabel.textColor = .blue300
        nameLabel.font = Fonts.head1B
        
        groupNameStackView.axis = .horizontal
        groupNameStackView.spacing = 4
        groupNameStackView.alignment = .center
        
        [nameLabel, changeGroupImageView].forEach { groupNameStackView.addArrangedSubview($0) }
        
        memberStackView = infoStackView(description: "그룹원")
        joinCodeStackView = infoStackView(description: "초대코드")
        endDateStackView = infoStackView(description: "종료일")
        
        memberInfoLabel.textColor = .grey0
        joinCodeInfoLabel.textColor = .grey0
        endDateInfoLabel.textColor = .grey0
        
        joinCodeInfoStackView.axis = .horizontal
        joinCodeInfoStackView.spacing = 2
        joinCodeInfoStackView.alignment = .center
        
        memberStackView.addArrangedSubview(memberInfoLabel)
        if hasCopyImage { [joinCodeInfoLabel, joinCodeCopyImageView].forEach { joinCodeInfoStackView.addArrangedSubview($0) } }
        joinCodeStackView.addArrangedSubview(hasCopyImage ? joinCodeInfoStackView : joinCodeInfoLabel)
        endDateStackView.addArrangedSubview(endDateInfoLabel)
        
        groupInfoStackView.axis = .horizontal
        groupInfoStackView.spacing = 16
        
        [memberStackView, joinCodeStackView, endDateStackView].forEach { groupInfoStackView.addArrangedSubview($0) }
        
        durationDescriptionLabel.text = "진행 현황"
        durationDescriptionLabel.textColor = .grey300
        durationDescriptionLabel.font = Fonts.body2R
        
        durationInfoLabel.textColor = .grey300
        durationInfoLabel.font = Fonts.smallR
        
        durationProgressView.layer.cornerRadius = 4
        durationProgressView.clipsToBounds = true
        durationProgressView.trackTintColor = .grey800
        durationProgressView.progressTintColor = .blue300
        
        if let durationProgressLayer = durationProgressView.subviews.last {
            durationProgressLayer.layer.cornerRadius = 4
            durationProgressLayer.clipsToBounds = true
        }
        
        durationStackView.axis = .horizontal
        durationStackView.alignment = .center
        
        [durationDescriptionLabel, durationInfoLabel, durationProgressView].forEach { durationStackView.addArrangedSubview($0) }
        durationStackView.setCustomSpacing(2, after: durationDescriptionLabel)
        durationStackView.setCustomSpacing(8, after: durationInfoLabel)
        
        durationProgressView.transform = CGAffineTransform(translationX: 0, y: 1)   // MARK: 디자인 디테일 반영
    }
    
    override func configureAction() {
        groupNameStackView.addTapAction { [weak self] in
            guard let self else { return }
            delegate?.updateBottomSheetVisibleAction(isShowSheet: true)
        }
        
        joinCodeStackView.addTapAction { [weak self] in
            guard let self else { return }
            delegate?.inviteAction()
        }
    }
    
    override func configureHierarchy() {
        [dosikImageView, groupNameStackView, groupInfoStackView, durationStackView].forEach { self.addSubview($0) }
    }
    
    override func configureConstraints() {
        dosikImageView.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        groupNameStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.left.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        changeGroupImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        groupInfoStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview()
        }
        
        joinCodeCopyImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        durationProgressView.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        
        durationStackView.snp.makeConstraints {
            $0.top.equalTo(groupInfoStackView.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(21)
        }
    }
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: (any BaseEntity)?) {
        if let data = data as? GroupEntity {
            nameLabel.text = data.name
            
            memberInfoLabel.attributedText = NSAttributedString(
                string: "\(data.currentMember)/\(data.maximumMember)",
                attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
            )
            joinCodeInfoLabel.attributedText = NSAttributedString(
                string: data.joinCode,
                attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
            )
            endDateInfoLabel.attributedText = NSAttributedString(
                string: data.endDate,
                attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
            )
            
            durationInfoLabel.text = "(\(data.duration)일차)"
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [weak self] in
                guard let self else { return }
                durationProgressView.setProgress(data.progress, animated: true)
            }
        }
    }
}

// MARK: private func
extension GroupInfoView {
    private func infoStackView(description: String) -> UIStackView {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: description,
            attributes: Fonts.getAttributes(for: Fonts.body2R, textAlignment: .left)
        )
        label.textColor = .grey300
        
        let stackView = UIStackView(arrangedSubviews: [label])
        stackView.axis = .vertical
        
        return stackView
    }
}
