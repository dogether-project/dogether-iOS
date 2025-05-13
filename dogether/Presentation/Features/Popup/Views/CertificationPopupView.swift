//
//  CertificationPopupView.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import UIKit
import SnapKit

final class CertificationPopupView: BasePopupView {
    // MARK: - PopupViewController에서 action handling
    var galleryButton = UIButton()
    var cameraButton = UIButton()
    var certificationButton = DogetherButton(title: "인증하기", status: .disabled)
    
    // MARK: - PopupViewController에서 delegate 지정
    let certificationTextView = DogetherTextView(type: .certification)
    
    init() {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private var imageView = CertificationImageView(image: .logo)
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "인증 하기"
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
    
    private let todoContentLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.numberOfLines = 0
        return label
    }()
    
    private func certificationButton(certificationMethod: CertificationMethods) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.grey500.cgColor
        button.layer.borderWidth = 1
        button.tag = certificationMethod.rawValue
        
        let imageView = UIImageView(image: certificationMethod.image)
        
        let label = UILabel()
        label.text = certificationMethod.title
        label.textColor = .grey300
        label.font = Fonts.body1S
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false
        
        button.addSubview(stackView)
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        return button
    }
    
    private let certificationStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 11
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let nextButton = DogetherButton(title: "다음", status: .enabled)
    
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "인증 내용을 보완해주세요!"
        label.textColor = .grey0
        label.textAlignment = .center
        label.font = Fonts.head1B
        return label
    }()
    
    private let descriptionView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.grey600.cgColor
        view.layer.borderWidth = 1
        
        let imageView = UIImageView(image: .notice)
        
        let label = UILabel()
        label.text = "한번 인증한 내용은 바꿀 수 없어요"
        label.textColor = .grey400
        label.font = Fonts.body2S
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        [stackView].forEach { view.addSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        return view
    }()
    
    override func configureView() {
        galleryButton = certificationButton(certificationMethod: .gallery)
        cameraButton = certificationButton(certificationMethod: .camera)
        [galleryButton, cameraButton].forEach { certificationStackView.addArrangedSubview($0) }
    }
    
    override func configureAction() {
        closeButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.hidePopup()
            }, for: .touchUpInside
        )
        
        nextButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                updatePopup()
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [titleLabel, closeButton, todoContentLabel, certificationStackView].forEach { addSubview($0) }
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
        
        todoContentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        certificationStackView.snp.makeConstraints {
            $0.top.equalTo(todoContentLabel.snp.bottom).offset(24)
            $0.bottom.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

extension CertificationPopupView {
    func setExtraInfo(todoInfo: TodoInfo?) {
        todoContentLabel.attributedText = NSAttributedString(
            string: todoInfo?.content ?? "",
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
    }
    
    func uploadImage(image: UIImage) {
        if imageView.image == .logo {
            [imageView, nextButton].forEach { addSubview($0) }
            
            imageView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(20)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(imageView.snp.width)
            }
            
            todoContentLabel.snp.remakeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(24)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
            
            certificationStackView.snp.remakeConstraints {
                $0.top.equalTo(todoContentLabel.snp.bottom).offset(24)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
            
            nextButton.snp.makeConstraints {
                $0.top.equalTo(certificationStackView.snp.bottom).offset(20)
                $0.bottom.equalToSuperview().inset(24)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
        }
        
        imageView.image = image
    }
    
    private func updatePopup() {
        [imageView, todoContentLabel, certificationStackView, nextButton].forEach {
            $0.snp.removeConstraints()
            $0.isHidden = true
        }
        
        certificationTextView.becomeFirstResponder()
        
        [descriptionLabel, descriptionView, certificationTextView, certificationButton].forEach { addSubview($0) }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        certificationTextView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(106)
        }
        
        certificationButton.snp.makeConstraints {
            $0.top.equalTo(certificationTextView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
