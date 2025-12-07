//
//  AlertStackView.swift
//  dogether
//
//  Created by seungyooooong on 12/7/25.
//

import UIKit

final class AlertStackView: BaseStackView {
    var delegate: AlertPopupDelegate? {
        didSet {
            cancelButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.hidePopup()
                }, for: .touchUpInside
            )
        }
    }
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let cancelButton = UIButton()
    private let confirmButton = UIButton()
    private let buttonStackView = UIStackView()
    
    private(set) var currentType: AlertTypes?
    
    override func configureView() {
        axis = .vertical
        
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.textColor = .grey0
        titleLabel.numberOfLines = 0
        
        messageLabel.textColor = .grey200
        messageLabel.numberOfLines = 0
        
        cancelButton.setTitleColor(.grey200, for: .normal)
        cancelButton.titleLabel?.font = Fonts.body1S
        cancelButton.layer.cornerRadius = 8
        cancelButton.backgroundColor = .grey500
        
        confirmButton.setTitleColor(.grey800, for: .normal)
        confirmButton.titleLabel?.font = Fonts.body1S
        confirmButton.layer.cornerRadius = 8
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.distribution = .fillEqually
    }
    
    override func configureAction() { addTapAction { _ in return } }
    
    override func configureHierarchy() {
        [cancelButton, confirmButton].forEach { buttonStackView.addArrangedSubview($0) }
        
        [imageView, titleLabel, messageLabel, buttonStackView].forEach { addArrangedSubview($0) }
        setCustomSpacing(12, after: imageView)
        setCustomSpacing(8, after: titleLabel)
        setCustomSpacing(24, after: messageLabel)
    }

    override func configureConstraints() {
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(48)
        }
 
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(40)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? AlertPopupViewDatas {
            if let type = datas.type, currentType != type {
                currentType = type
                
                if let image = type.image {
                    imageView.image = image
                    
                    if !arrangedSubviews.contains(imageView) {
                        insertArrangedSubview(imageView, at: 0)
                    }
                } else {
                    if arrangedSubviews.contains(imageView) {
                        removeArrangedSubview(imageView)
                    }
                }
                
                titleLabel.attributedText = NSAttributedString(
                    string: type.title,
                    attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
                )
                
                if let message = type.message {
                    messageLabel.attributedText = NSAttributedString(
                        string: message,
                        attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .center)
                    )
                }
                
                cancelButton.setTitle(type.cancelText, for: .normal)
                
                confirmButton.setTitle(type.buttonText, for: .normal)
                confirmButton.backgroundColor = type.buttonColor
            }
        }
    }
}
