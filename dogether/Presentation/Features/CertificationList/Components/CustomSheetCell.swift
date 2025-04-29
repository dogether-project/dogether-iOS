//
//  CustomSheetCell.swift
//  dogether
//
//  Created by yujaehong on 4/28/25.
//

import UIKit

class CustomSheetCell: UITableViewCell {
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .grey0
        label.backgroundColor = .clear
        return label
    }()

    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .blue300
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .grey700
        
        contentView.addSubview(optionLabel)
        contentView.addSubview(checkmarkImageView)
        
        optionLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(24)
            $0.centerY.equalTo(contentView)
        }
        
        checkmarkImageView.snp.makeConstraints {
            $0.trailing.equalTo(contentView).inset(24)
            $0.centerY.equalTo(contentView)
            $0.width.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(option: String, isSelected: Bool) {
        optionLabel.text = option
        checkmarkImageView.isHidden = !isSelected
    }
}
