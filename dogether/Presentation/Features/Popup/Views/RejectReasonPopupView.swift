//
//  RejectReasonPopupView.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import UIKit
import SnapKit

final class RejectReasonPopupView: BasePopupView {
    private let rejectReasonMaxLength = 60
    
    init() {
        super.init(frame: .zero)
        setUI()
        setupKeyboardHandling()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let closeButton = {
        let button = UIButton()
        button.setImage(.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey0
        return button
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "이유를 들려주세요 !"
        label.textColor = .grey0
        label.textAlignment = .center
        label.font = Fonts.head1B
        return label
    }()
    
    private func descriptionView(tempParameter: Bool = false) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.grey600.cgColor
        view.layer.borderWidth = 1
        
        let imageView = UIImageView(image: .notice)
        
        let label = UILabel()
        label.text = "한번 등록한 피드백은 바꿀 수 없어요"
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
    }
    private var descriptionView = UIView()
    
    private let rejectReasonView = {
        let view = UIView()
        view.backgroundColor = .grey800
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.blue300.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let rejectReasonPlaceHolder = {
        let label = UILabel()
        label.textColor = .grey300
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private func rejectReasonTextView(tempParameter: Bool = false) -> UITextView {
        let textView = UITextView()
        textView.text = ""
        textView.textColor = .grey50
        textView.font = Fonts.body1R
        textView.tintColor = .blue300
        textView.backgroundColor = .clear
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.delegate = self
        return textView
    }
    private var rejectReasonTextView = UITextView()
    
    private let rejectReasonTextCountLabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .blue300
        label.font = Fonts.smallS
        return label
    }()
    
    private let rejectReasonMaxLengthLabel = {
        let label = UILabel()
        label.textColor = .grey400
        label.font = Fonts.smallS
        return label
    }()
    
    private var rejectReasonButton = DogetherButton(title: "등록하기", status: .disabled)
    
    private func setUI() {
        backgroundColor = .grey700
        layer.cornerRadius = 12
        
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        descriptionView = descriptionView()
        rejectReasonPlaceHolder.attributedText = NSAttributedString(
            string: "팀원이 이해하기 쉽도록 인증에 대한 설명을 입력하세요.",
            attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .left)
        )
        rejectReasonTextView = rejectReasonTextView()
        rejectReasonTextView.becomeFirstResponder()
        rejectReasonMaxLengthLabel.text = "/\(rejectReasonMaxLength)"
        rejectReasonButton.addTarget(self, action: #selector(didTapRejectReasonButton), for: .touchUpInside)
        
        [
            closeButton, descriptionLabel, descriptionView,
            rejectReasonView, rejectReasonPlaceHolder, rejectReasonTextView,
            rejectReasonTextCountLabel, rejectReasonMaxLengthLabel,
            rejectReasonButton
        ].forEach { addSubview($0) }
        
        self.snp.updateConstraints {
            $0.height.equalTo(422)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        rejectReasonView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(160)
        }
        
        rejectReasonPlaceHolder.snp.makeConstraints {
            $0.top.equalTo(rejectReasonView).offset(16)
            $0.horizontalEdges.equalTo(rejectReasonView).inset(16)
            $0.width.equalTo(271)
        }
        
        rejectReasonTextView.snp.makeConstraints {
            $0.top.equalTo(rejectReasonView).offset(22)
            $0.horizontalEdges.equalTo(rejectReasonView).inset(16)
            $0.width.equalTo(271)
            $0.height.equalTo(100)
        }
        
        rejectReasonTextCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(rejectReasonView).inset(16)
            $0.right.equalTo(rejectReasonMaxLengthLabel.snp.left)
            $0.height.equalTo(18)
        }
        
        rejectReasonMaxLengthLabel.snp.makeConstraints {
            $0.bottom.equalTo(rejectReasonView).inset(16)
            $0.right.equalTo(rejectReasonView).inset(16)
            $0.height.equalTo(18)
        }
        
        rejectReasonButton.snp.makeConstraints {
            $0.top.equalTo(rejectReasonView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func didTapCloseButton() {
        delegate?.hidePopup()
    }
    
    @objc private func didTapRejectReasonButton() {
        delegate?.rejectPopupCompletion?(rejectReasonTextView.text)
        delegate?.hidePopup()
    }
}

// MARK: - abount keyboard
extension RejectReasonPopupView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            if text.count > rejectReasonMaxLength {
                textView.text = String(text.prefix(rejectReasonMaxLength))
            }
            rejectReasonPlaceHolder.isHidden = text.count > 0
            rejectReasonTextCountLabel.text = String(textView.text.count)
            rejectReasonButton.setButtonStatus(status: text.count > 0 ? .enabled : .disabled)
        }
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - UITextFieldDelegate
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        self.snp.updateConstraints { $0.centerY.equalToSuperview().offset(-keyboardHeight / 2) }
        UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.snp.updateConstraints { $0.centerY.equalToSuperview() }
        UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
    }
}
