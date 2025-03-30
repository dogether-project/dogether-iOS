//
//  TodoWriteTableViewCell.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import UIKit

class TodoWriteTableViewCell: UITableViewCell, ReusableProtocol {
    private let tableViewCell = {
        let view = UIView()
        view.backgroundColor = .grey800
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let todoLabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        label.textColor = .grey50
        return label
    }()
    
    private let deleteButton = {
        let button = UIButton()
        button.setImage(.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey300
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    func setExtraInfo(text: String, index: Int, deleteAction: @escaping (Int) -> Void) {
        todoLabel.text = text
        deleteButton.tag = index
        deleteButton.removeTarget(nil, action: nil, for: .touchUpInside)
        deleteButton.addAction(
            UIAction { [weak deleteButton] _ in
                guard let deleteButton else { return }
                deleteAction(deleteButton.tag)
            }, for: .touchUpInside
        )
    }
    
    private func setUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(tableViewCell)
        
        [todoLabel, deleteButton].forEach { tableViewCell.addSubview($0) }
    
        tableViewCell.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.height.equalTo(64)
        }
        
        todoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(20)
        }
    }
}
