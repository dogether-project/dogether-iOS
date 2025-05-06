//
//  SortFilterButton.swift
//  dogether
//
//  Created by yujaehong on 4/25/25.
//

import UIKit

enum SortOption: String, CaseIterable {
    case todoCompletionDate = "투두 완료일순"
    case groupCreationDate = "그룹 생성일순"

    var displayName: String {
        return self.rawValue
    }
}

/// SortFilterButton은 필터 옵션을 선택하는 버튼을 나타냅니다.
final class SortFilterButton: BaseButton {
    
    var sortSelected: ((SortOption) -> Void)?
    
    private var selectedOption: SortOption = .todoCompletionDate
    
    let filterOptions: [SortOption] = [.todoCompletionDate, .groupCreationDate]
    
    let sortTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    // 필터 선택 여부를 나타내는 변수
    private var isSelectedFilter: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let firstOption = filterOptions.first {
            selectedOption = firstOption
            sortTitleLabel.text = firstOption.displayName
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey500.cgColor
        clipsToBounds = true
    }
    
    override func configureAction() {
        arrowButton.addAction(
            UIAction { [weak self] _ in
                guard let self = self, self.isSelectedFilter else { return }
                self.presentCustomSheet()
            },
            for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        addSubview(sortTitleLabel)
        addSubview(arrowButton)
    }
    
    override func configureConstraints() {
        snp.makeConstraints {
            $0.width.equalTo(116)
            $0.height.equalTo(32)
        }
        
        sortTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        arrowButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(19)
        }
    }
}

// 필터 선택 상태에 따른 UI 업데이트
extension SortFilterButton {
    func setIsSelectedFilter(_ selected: Bool) {
        self.isSelectedFilter = selected
        updateUI()
    }
    
    private func updateUI() {
        if isSelectedFilter {
            sortTitleLabel.textColor = .white
            arrowButton.tintColor = .white
            layer.borderColor = UIColor.white.cgColor
        } else {
            sortTitleLabel.textColor = .grey300
            arrowButton.tintColor = .grey300
            layer.borderColor = UIColor.grey300.cgColor
        }
    }
}

extension SortFilterButton {
    func presentCustomSheet() {
        guard let parentVC = findViewController() else { return }

        let sheetVC = CustomSheetViewController(titleText: "정렬", filterOptions: filterOptions, selectedOption: selectedOption)
        sheetVC.modalPresentationStyle = .overCurrentContext
        sheetVC.modalTransitionStyle = .coverVertical
        
        sheetVC.didSelectOption = { [weak self] selectedOption in
            //self?.sortTitleLabel.text = selectedOption
            self?.selectedOption = selectedOption
            self?.sortTitleLabel.text = selectedOption.displayName
            self?.setIsSelectedFilter(true)
            self?.sortSelected?(selectedOption) // 정렬 옵션을 filterView에 전달
        }
        
        parentVC.present(sheetVC, animated: true)
    }
    
    // 현재 뷰의 부모 뷰 컨트롤러를 찾는 메서드
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
