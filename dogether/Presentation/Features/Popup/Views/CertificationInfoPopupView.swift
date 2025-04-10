//
//  CertificationInfoPopupView.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import UIKit
import SnapKit

final class CertificationInfoPopupView: BasePopupView {
    private let todoInfo: TodoInfo
    
    init(todoInfo: TodoInfo) {
        self.todoInfo = todoInfo
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "인증 정보"
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    
    private let closeButton = {
        let button = UIButton()
        button.setImage(.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey0
        return button
    }()
    
    private var imageView = UIImageView()
    
    private var statusView = FilterButton(type: .all)
    
    private let contentLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.numberOfLines = 0
        return label
    }()
    
    private func rejectReasonView(reason: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .grey600
        view.layer.cornerRadius = 8
        
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: reason,
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        label.textColor = .grey100
        label.numberOfLines = 0
        
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
        
        return view
    }
    private var rejectReasonView = UIView()
    
    override func configureView() {
        loadImage()
        
        imageView = CertificationImageView(
            image: .logo,
            certificationContent: todoInfo.certificationContent ?? "",
            certificator: UserDefaultsManager.shared.userFullName ?? ""
        )
        
        guard let status = TodoStatus(rawValue: todoInfo.status),
              let filterType = FilterTypes.allCases.first(where: { $0.tag == status.tag }) else { return }
        statusView = FilterButton(type: filterType)
        
        contentLabel.attributedText = NSAttributedString(
            string: todoInfo.content,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
    }
    
    override func configureAction() {
        closeButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.hidePopup()
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [titleLabel, closeButton, imageView, statusView, contentLabel].forEach { addSubview($0) }
    }
     
    override func configureConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(28)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(24)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(imageView.snp.width)
        }
        
        statusView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.height.equalTo(32)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(statusView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        if let rejectReason = todoInfo.rejectReason {
            rejectReasonView = rejectReasonView(reason: rejectReason)
            addSubview(rejectReasonView)
            rejectReasonView.snp.makeConstraints {
                $0.top.equalTo(contentLabel.snp.bottom).offset(16)
                $0.bottom.equalToSuperview().inset(24)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
        } else {
            contentLabel.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(24)
            }
        }
    }
}

extension CertificationInfoPopupView {
    private func loadImage() {
        Task {
            guard let mediaUrl = self.todoInfo.certificationMediaUrl, let url = URL(string: mediaUrl) else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                imageView.image = UIImage(data: data)
            }
        }
    }
}
