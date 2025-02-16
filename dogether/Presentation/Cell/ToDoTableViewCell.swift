//
//  ToDoTableViewCell.swift
//  dogether
//
//  Created by 박지은 on 2/13/25.
//

import UIKit
import SnapKit

class ToDoTableViewCell: BaseTableViewCell, ReusableProtocol {
    
    let todoLabel = {
        let label = UILabel()
        label.font = Fonts.body1S
        label.textColor = .grey50
        return label
    }()
    
    let deleteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setTitleColor(.grey300, for: .normal)
        button.backgroundColor = .red
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
            $0.width.height.equalTo(20)
        }
    }
    
    override func configureView() {

        contentView.backgroundColor = .yellow
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
