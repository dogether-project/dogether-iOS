//
//  CertificationViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import UIKit

final class CertificationViewController: BaseViewController {
    private let certificationPage = CertificationPage()
    private let viewModel = CertificationViewModel()
    
    override func viewDidLoad() {
        certificationPage.delegate = self
        
        pages = [certificationPage]

        super.viewDidLoad()
        
        onAppear()
    }
    
    override func setViewDatas() {
//        if let datas = datas as? CertificationViewDatas {
//            viewModel.certificationViewDatas.accept(datas)
//        }
        
        bind(viewModel.certificationViewDatas)
    }
}

extension CertificationViewController {
    private func onAppear() {
        Task { [weak self] in
            guard let self else { return }
            // TODO: 상황에 따른 API 호출 및 데이터 바인딩 로직 추가
            try await viewModel.readTodo()
        }
    }
}

// MARK: - delegate
protocol CertificationDelegate {
    func thumbnailTapAction(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer)
    func certificationTapAction(_ scrollView: UIScrollView, _ stackView: UIStackView, _ gesture: UITapGestureRecognizer)
    func certificationListScrollEndAction(index: Int)
    func goCertificateViewAction(todo: TodoEntity)
    func remindTodoAction(remindType: RemindTypes, todoId: Int)
}

extension CertificationViewController: CertificationDelegate {
    func thumbnailTapAction(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: stackView)

        for (index, view) in stackView.arrangedSubviews.enumerated() {
            if view.frame.contains(location) {
                Task { [weak self] in
                    guard let self else { return }
                    try await viewModel.setIndex(index: index)
                }
                return
            }
        }
    }
    
    func certificationTapAction(
        _ scrollView: UIScrollView,
        _ stackView: UIStackView,
        _ gesture: UITapGestureRecognizer
    ) {
        let location = gesture.location(in: scrollView)
        let scrollViewWidth = scrollView.bounds.width
        
        // MARK: view 중앙을 기준으로 direction 결정
        let direction: Directions = location.x - scrollView.contentOffset.x < scrollViewWidth / 2 ? .prev : .next
        let index = Int(round(scrollView.contentOffset.x / scrollViewWidth))
        let nextIndex = index + direction.tag
        
        if nextIndex < 0 || stackView.arrangedSubviews.count <= nextIndex { return }
        
        let newOffset = CGPoint(x: scrollViewWidth * CGFloat(nextIndex), y: 0)
        UIView.animate(withDuration: 0.3, animations: {
            scrollView.setContentOffset(newOffset, animated: false)
        }, completion: { [weak self] finished in
            guard let self else { return }
            if finished { Task { try await self.viewModel.setIndex(index: nextIndex) } }
        })
    }
    
    func certificationListScrollEndAction(index: Int) {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.setIndex(index: index)
        }
    }
    
    func goCertificateViewAction(todo: TodoEntity) {
        let certificateImageViewController = CertificateImageViewController()
        let certificateViewDatas = CertificateViewDatas(todo: todo)
        coordinator?.pushViewController(certificateImageViewController, datas: certificateViewDatas)
    }
    
    func remindTodoAction(remindType: RemindTypes, todoId: Int) {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.remindTodo(remindType: remindType, todoId: todoId)
            // TODO: 재촉 메시지가 전송되었어요 토스트 메시지 노출 및 버튼 비활성화
        }
    }
}
