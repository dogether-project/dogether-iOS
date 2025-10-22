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
    }
    
    override func setViewDatas() {
        if let datas = datas as? CertificationViewDatas {
            // FIXME: 더미 데이터, 추후 삭제
            let temp = CertificationViewDatas(
                todos: [
                    TodoEntity(id: 0, content: "test", status: "CERTIFY_PENDING"),
                    datas.todos[0],
                ],
                index: datas.index
            )
            viewModel.certificationViewDatas.accept(temp)   // FIXME: temp -> datas
        }
        
        bind(viewModel.certificationViewDatas)
    }
}

// MARK: - delegate
protocol CertificationDelegate {
    func thumbnailTapAction(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer)
    func certificationTapAction(_ scrollView: UIScrollView, _ stackView: UIStackView, _ gesture: UITapGestureRecognizer)
}

extension CertificationViewController: CertificationDelegate {
    func thumbnailTapAction(_ stackView: UIStackView, _ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: stackView)

        for (index, view) in stackView.arrangedSubviews.enumerated() {
            if view.frame.contains(location) {
                viewModel.certificationViewDatas.update { $0.index = index }
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
        scrollView.setContentOffset(newOffset, animated: true)
    }
}
