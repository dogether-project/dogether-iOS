//
//  CompletePage.swift
//  dogether
//
//  Created by yujaehong on 10/26/25.
//

import UIKit

final class CompletePage: BasePage {
    weak var delegate: CompleteDelegate?

    private let firecrackerImageView = UIImageView(image: .firecracker)
    private let titleLabel = UILabel()
    private let completeButton = DogetherButton(title: "홈으로 가기", status: .enabled)
    private var groupInfoView = UIView()
    private var joinCodeShareButton = UIButton()

    private func joinCodeShareButton(joinCode: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 12

        let label = UILabel()
        label.text = joinCode
        label.textColor = .grey0
        label.font = Fonts.head1B

        let imageView = UIImageView()
        imageView.image = .share.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey400

        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false

        button.addSubview(stackView)
        stackView.snp.makeConstraints { $0.center.equalToSuperview() }
        label.snp.makeConstraints { $0.height.equalTo(36) }
        imageView.snp.makeConstraints { $0.width.height.equalTo(24) }

        return button
    }

    private let noticeView = {
        let imageView = UIImageView(image: .notice)
        let label = UILabel()
        label.text = "카카오톡, 문자 등을 통해 공유해보세요 !"
        label.textColor = .grey400
        label.font = Fonts.body2R

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 4
        imageView.snp.makeConstraints { $0.width.height.equalTo(20) }
        return stackView
    }()

    override func configureView() {
        titleLabel.textColor = .grey0
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }

    override func configureAction() {
        completeButton.addAction(
            UIAction { [weak self] _ in
                self?.delegate?.goHomeAction()
            },
            for: .touchUpInside
        )
    }

    override func configureHierarchy() {
        [firecrackerImageView, titleLabel, completeButton].forEach { addSubview($0) }
    }

    override func configureConstraints() {
        firecrackerImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(68)
            $0.width.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(firecrackerImageView.snp.bottom).offset(20)
            $0.height.equalTo(72)
        }

        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    override func updateView(_ data: (any BaseEntity)?) {
        guard let datas = data as? CompleteViewDatas else { return }

        titleLabel.attributedText = NSAttributedString(
            string: datas.groupType.completeTitleText,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )

        groupInfoView.removeFromSuperview()
        joinCodeShareButton.removeFromSuperview()
        noticeView.removeFromSuperview()

        switch datas.groupType {
        case .join:
            groupInfoView = DogetherGroupInfo(
                groupName: datas.groupInfo.name,
                memberCount: datas.groupInfo.maximumMember,
                duration: datas.groupInfo.duration,
                startAtString: datas.groupInfo.startDate,
                endAtString: datas.groupInfo.endDate
            )
            addSubview(groupInfoView)
            groupInfoView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(40)
                $0.horizontalEdges.equalToSuperview().inset(36)
                $0.height.equalTo(269)
            }

        case .create:
            joinCodeShareButton = joinCodeShareButton(joinCode: datas.joinCode)
            addSubview(joinCodeShareButton)
            addSubview(noticeView)

            joinCodeShareButton.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(68)
                $0.horizontalEdges.equalToSuperview().inset(36)
                $0.height.equalTo(75)
            }

            noticeView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(joinCodeShareButton.snp.bottom).offset(16)
            }

            joinCodeShareButton.addAction(
                UIAction { [weak self] _ in
                    self?.delegate?.shareJoinCodeAction()
                },
                for: .touchUpInside
            )
        }
    }
}
