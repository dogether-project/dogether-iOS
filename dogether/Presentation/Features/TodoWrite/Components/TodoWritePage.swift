//
//  TodoWritePage.swift
//  dogether
//
//  Created by seungyooooong on 10/3/25.
//

import UIKit

final class TodoWritePage: BasePage {
    var delegate: TodoWriteDelegate? {
        didSet {
            
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "투두 작성")
    
    private let dateLabel = UILabel()
    private let todoLimitLabel = UILabel()
    
    private let todoTextField = UITextField()
    private let todoLimitTextCount = UILabel()
    
    private let addButton = UIButton()
    private let addButtonImageView = UIImageView()
    
    private let emptyListView = {
        let imageView = UIImageView(image: .embarrassedDosik)
        imageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: "아직 작성된 투두가 없어요",
            attributes: Fonts.getAttributes(for: Fonts.head2B, textAlignment: .center)
        )
        titleLabel.textColor = .grey400
        
        let subTitleLabel = UILabel()
        subTitleLabel.attributedText = NSAttributedString(
            string: "오늘 하루 이루고 싶은 목표를 입력해보세요!",
            attributes: Fonts.getAttributes(for: Fonts.body2R, textAlignment: .center)
        )
        subTitleLabel.textColor = .grey400
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.setCustomSpacing(17, after: imageView)
        stackView.setCustomSpacing(0, after: titleLabel)
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(129)
            $0.height.equalTo(148)
        }
        
        return stackView
    }()
    
    private let todoTableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let saveButton = DogetherButton(title: "투두 저장", status: .disabled)
    
    
    
    override func configureView() {
        dateLabel.attributedText = NSAttributedString(
            string: DateFormatterManager.formattedDate(format: .MdE),
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        dateLabel.textColor = .grey400
        todoLimitLabel.textColor = .grey0
        
        todoTextField.font = Fonts.body1S
        todoTextField.tintColor = .blue300
        todoTextField.textColor = .grey0
        todoTextField.returnKeyType = .done
        todoTextField.borderStyle = .none
        todoTextField.backgroundColor = .grey800
        todoTextField.layer.cornerRadius = 12
        todoTextField.layer.borderWidth = 0
        todoTextField.layer.borderColor = UIColor.blue300.cgColor
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: todoTextField.frame.height))
        todoTextField.leftView = leftPaddingView
        todoTextField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: todoTextField.frame.height))
        todoTextField.rightView = rightPaddingView
        todoTextField.rightViewMode = .always
        
        todoLimitTextCount.textColor = .grey500
        todoLimitTextCount.font = Fonts.smallS
        
        addButton.backgroundColor = .grey600
        addButton.layer.cornerRadius = 8
        addButton.tintColor = .grey400
        
        addButtonImageView.image = .plus.withRenderingMode(.alwaysTemplate)
        addButtonImageView.isUserInteractionEnabled = false
    }
    
    override func configureAction() {
        addTapAction { [weak self] in
            guard let self else { return }
            endEditing(true)
        }
    }
    
    override func configureHierarchy() {
        addButton.addSubview(addButtonImageView)
        
        [ navigationHeader, dateLabel, todoLimitLabel,
          todoTextField, todoLimitTextCount, addButton,
          emptyListView, todoTableView, saveButton
        ].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        todoLimitLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        todoTextField.snp.makeConstraints {
            $0.top.equalTo(todoLimitLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(72)
            $0.height.equalTo(50)
        }
        
        todoLimitTextCount.snp.makeConstraints {
            $0.centerY.equalTo(todoTextField)
            $0.trailing.equalTo(todoTextField.snp.trailing).inset(8)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(todoTextField)
            $0.leading.equalTo(todoTextField.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(48)
        }
        
        addButtonImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        emptyListView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(todoTextField.snp.bottom).offset(101)
        }
        
        todoTableView.snp.makeConstraints {
            $0.top.equalTo(todoTextField.snp.bottom).offset(22)
            $0.bottom.equalTo(saveButton.snp.top).offset(-10)
            $0.left.right.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
