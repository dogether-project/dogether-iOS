//
//  SheetHeaderView.swift
//  dogether
//
//  Created by seungyooooong on 4/27/25.
//

import UIKit

final class SheetHeaderView: BaseView {
    var delegate: MainDelegate?
    
    private let dateLabel = UILabel()
    
    private let prevButton = UIButton()
    private let nextButton = UIButton()
    
    override func configureView() {
        dateLabel.textColor = .grey0
        dateLabel.font = Fonts.head2B
        
        prevButton.setImage(.prevButton, for: .normal)
        prevButton.setImage(.prevButtonDisabled, for: .disabled)
        prevButton.tag = Directions.prev.tag
        prevButton.isEnabled = false
        
        nextButton.setImage(.nextButton, for: .normal)
        nextButton.setImage(.nextButtonDisabled, for: .disabled)
        nextButton.tag = Directions.next.tag
        nextButton.isEnabled = false
    }
    
    override func configureAction() {
        prevButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.goPastAction()
            }, for: .touchUpInside
        )
        
        nextButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.goFutureAction()
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [dateLabel, prevButton, nextButton].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        prevButton.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        
        nextButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.width.height.equalTo(32)
        }
    }
    
    // MARK: - viewDidUpdate
    override func updateView(_ data: (any BaseEntity)?) {
        if let data = data as? SheetViewDatas {
            dateLabel.text = data.date
            
//            prevButton.isEnabled = viewModel.dateOffset * -1 < viewModel.currentGroup.duration - 1
//            nextButton.isEnabled = viewModel.dateOffset < 0
        }
        
//        let currentDate = DateFormatterManager.formattedDate(viewModel.dateOffset)
//        sheetHeaderView.setDate(date: currentDate)
    }
}
