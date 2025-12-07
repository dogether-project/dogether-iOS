//
//  PopupViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit
import SnapKit

import Combine

final class PopupViewController: BaseViewController {
    private let popupPage = PopupPage()
    var viewModel = PopupViewModel()
    
    var completion: ((Any) -> Void)?
    
    private var popupViewCenterYConstraint: Constraint?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        popupPage.delegate = self
        
        pages = [popupPage]
        
        super.viewDidLoad()
        
        onAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if let popupView = popupView as? ReviewFeedbackPopupView {
//            popupView.reviewFeedbackTextView.becomeFirstResponder()
//        }
    }
    
    override func setViewDatas() {
        if let datas = datas as? AlertPopupViewDatas {
            viewModel.alertPopupViewDatas.accept(datas)
        }
        
        bind(viewModel.alertPopupViewDatas)
    }
}

//extension PopupViewController {
//    private func getPopupView() -> BasePopupView {
//        guard let popupType = viewModel.popupType else { return BasePopupView() }
//        switch popupType {
//        case .alert:
//            guard let alertType = viewModel.alertType else { return BasePopupView() }
//            let alertView = AlertPopupView(type: alertType)
//            alertView.confirmButton.addAction(
//                UIAction { [weak self] _ in
//                    guard let self else { return }
//                    completion?(())
//                    hidePopup()
//                }, for: .touchUpInside
//            )
//            return alertView
//            
//        case .reviewFeedback:
//            let reviewFeedbackPopupView = ReviewFeedbackPopupView()
//            reviewFeedbackPopupView.reviewFeedbackTextView.delegate = self
//            reviewFeedbackPopupView.reviewFeedbackButton.addAction(
//                UIAction { [weak self] _ in
//                    guard let self, let reviewFeedback = viewModel.stringContent else { return }
//                    completion?(reviewFeedback)
//                    hidePopup()
//                }, for: .touchUpInside
//            )
//            return reviewFeedbackPopupView
//        }
//    }
//}

// MARK: - about keyboard
extension PopupViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        guard let textView = textView as? DogetherTextView else { return false }
        let currentText = textView.text ?? ""
        
        guard let textRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: textRange, with: text)
        
        return updatedText.count <= textView.type.maxLength
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let textView = textView as? DogetherTextView else { return }
        textView.updateTextInfo()
        viewModel.setStringContent(textView.text)
        
//        if let popupView = popupView as? ReviewFeedbackPopupView {
//            // FIXME: 추후 수정
//            var viewDatas = popupView.reviewFeedbackButton.currentViewDatas ?? DogetherButtonViewDatas(status: .disabled)
//            viewDatas.status = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//            ? .disabled
//            : .enabled
//            popupView.reviewFeedbackButton.updateView(viewDatas)
//        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let textView = textView as? DogetherTextView else { return false }
        textView.focusOn()
        
//        if let popupView = popupView as? ReviewFeedbackPopupView {
//            popupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
//        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let textView = textView as? DogetherTextView else { return false }
        textView.focusOff()
        
//        if let popupView = popupView as? ReviewFeedbackPopupView {
//            popupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
//        }
        return true
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
    
    
    private func observeKeyboardNotifications() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification -> CGFloat? in
                guard let userInfo = notification.userInfo,
                      let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                    return nil
                }
                return frameValue.cgRectValue.height
            }
            .sink { [weak self] height in
                guard let self else { return }
                updateUIForKeyboard(keyboardHeight: height)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                guard let self else { return }
                updateUIForKeyboard(keyboardHeight: 0)
            }
            .store(in: &cancellables)
    }
    
    private func updateUIForKeyboard(keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.35) { [weak self] in
            guard let self = self else { return }
            
            let safeAreaTop = view.safeAreaInsets.top
            let safeAreaHeight = view.frame.height - keyboardHeight - safeAreaTop
            let newCenterY = safeAreaTop + safeAreaHeight / 2
            
            popupViewCenterYConstraint?.update(offset: newCenterY - view.bounds.midY)
            
            view.layoutIfNeeded()
        }
    }
}

protocol AlertPopupDelegate {
    func hidePopup()
}

extension PopupViewController: AlertPopupDelegate {
    private func onAppear() {
        // MARK: - setup for popup ui
        // FIXME: 추후 수정
        view.backgroundColor = .grey900.withAlphaComponent(0.8)
        view.addTapAction { [weak self] _ in
            guard let self else { return }
            hidePopup()
        }
        pages?.forEach { page in
            page.snp.remakeConstraints {
                $0.centerX.equalTo(view)
                $0.horizontalEdges.equalTo(view).inset(16)

                $0.centerY.equalTo(view)
//                popupViewCenterYConstraint = $0.centerY.equalToSuperview().constraint
            }
        }
        
        // FIXME: 추후 수정
        observeKeyboardNotifications()
    }
    
    func hidePopup() {
        coordinator?.hidePopup()
    }
}
