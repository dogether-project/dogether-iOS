//
//  ModalityViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import UIKit
import SnapKit

final class ModalityViewController: BaseViewController {
    private let examinatePage = ExaminatePage()
    private let viewModel = ModalityViewModel()
    
    override func viewDidLoad() {
        examinatePage.delegate = self
        
        pages = [examinatePage]

        super.viewDidLoad()
    }
    
    override func setViewDatas() {
        bind(viewModel.examinateViewDatas)
        bind(viewModel.examinateButtonViewDatas)
    }
    
//    func updateView() {
//        todoExaminationModalityView.setReview(review: viewModel.reviews[viewModel.current])
//    }
}

protocol ExaminateDelegate {
    func updateReviewsAction(reviews: [ReviewEntity])
}

extension ModalityViewController: ExaminateDelegate {
    func updateReviewsAction(reviews: [ReviewEntity]) {
        viewModel.setReviews(reviews: reviews)
        
    }
}
