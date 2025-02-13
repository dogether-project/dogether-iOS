//
//  ToDoTableViewCell.swift
//  dogether
//
//  Created by 박지은 on 2/13/25.
//

import UIKit
import SnapKit

class ToDoTableViewCell: BaseTableViewCell, ReusableProtocol {
    
    private let todoLabel = {
        let label = UILabel()
        return label
    }()
    
    private let deleteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        [todoLabel, deleteButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        todoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
