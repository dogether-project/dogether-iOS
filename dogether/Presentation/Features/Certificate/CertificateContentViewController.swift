//
//  CertificateContentViewController.swift
//  dogether
//
//  Created by seungyooooong on 5/13/25.
//

import UIKit

final class CertificateContentViewController: BaseViewController {
    private let certificateContentPage = CertificateContentPage()
    private let viewModel = CertificateViewModel()
    
    override func viewDidLoad() {
        certificateContentPage.delegate = self
        
        pages = [certificateContentPage]

        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.updateIsFirstResponder(isFirstResponder: true)
    }
    
    override func setViewDatas() {
        if let datas = datas as? CertificateViewDatas {
            viewModel.certificateViewDatas.accept(datas)
        }
        
        bind(viewModel.certificateViewDatas)
        bind(viewModel.certificateTextViewDatas)
        bind(viewModel.certificateButtonViewDatas)
    }
}

protocol CertificateContentDelegate {
    func updateKeyboardHeightAction(height: CGFloat)
    func updateContentAction(content: String)
    func certifyTodoAction()
}

extension CertificateContentViewController: CertificateContentDelegate {
    func updateKeyboardHeightAction(height: CGFloat) {
        viewModel.updateKeyboardHeight(height: height)
        viewModel.updateIsFirstResponder(isFirstResponder: height > 0)
    }
    
    func updateContentAction(content: String) {
        viewModel.updateContent(content: content)
    }
    
    func certifyTodoAction() {
        tryCertifyTodo()
    }
}

extension CertificateContentViewController {
    private func tryCertifyTodo() {
        Task {
            do {
                try await self.viewModel.certifyTodo()
                
                // FIXME: certifyTodo 함수 안에서 에러 케이스 핸들링 하시면서 수정해주세요, 아래 3라인은 성공했을 때 액션입니다
                await MainActor.run {
                    self.coordinator?.popViewControllers(num: 2)
                }
            } catch let error as NetworkError {
                ErrorHandlingManager.presentErrorView(
                    error: error,
                    presentingViewController: self,
                    coordinator: self.coordinator,
                    retryHandler: { [weak self] in
                        self?.tryCertifyTodo()
                    }
                )
            }
        }
    }
}
