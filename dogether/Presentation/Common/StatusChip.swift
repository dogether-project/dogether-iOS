//
//  StatusChip.swift
//  dogether
//
//  Created by yujaehong on 2/2/26.
//

import UIKit

enum StatusChipMode {
    case selectable(FilterTypes)
    case display
}

final class StatusChip: BaseButton {
    // MARK: - Delegates
    var mainDelegate: MainDelegate? {
        didSet {
            guard case let .selectable(filterType) = mode else { return }
            addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    mainDelegate?.selectFilterAction(filterType: filterType)
                }, for: .touchUpInside
            )
        }
    }
    
    var certificationListDelegate: CertificationListPageDelegate? {
        didSet {
            guard case let .selectable(filterType) = mode else { return }
            addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    certificationListDelegate?.selectFilterAction(filterType: filterType)
                }, for: .touchUpInside
            )
        }
    }
    
    private let mode: StatusChipMode
    
    private let icon = UIImageView()
    private let label = UILabel()
    private let stackView = UIStackView()
    
    // MARK: - Initializers
    
    init(filterType: FilterTypes) {
        self.mode = .selectable(filterType)
        super.init(frame: .zero)
    }
    
    init() {
        self.mode = .display
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Configure
    
    override func configureView() {
        layer.cornerRadius = 16

        switch mode {
        case let .selectable(filterType):
            layer.borderWidth = 1
            icon.image = filterType.image?.withRenderingMode(.alwaysTemplate)
            label.text = filterType.text
        case .display:
            layer.borderWidth = 0
        }

        label.font = Fonts.body2S
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
    }
    
    override func configureAction() { }
    
    override func configureHierarchy() {
        let views = icon.image == nil ? [label] : [icon, label]
        views.forEach { stackView.addArrangedSubview($0) }
        
        addSubview(stackView)
    }
    
    override func configureConstraints() {
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.center.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }
    
    // MARK: - updateView
    
    override func updateView(_ data: any BaseEntity) {
        switch mode {
        case let .selectable(filterType):
            updateSelectableStyle(data, filterType: filterType)
        case .display:
            updateDisplayStyle(data)
        }
    }
    
    private func updateSelectableStyle(_ data: any BaseEntity, filterType: FilterTypes) {
        guard let selectedFilter = data as? FilterTypes else { return }
        
        let isSelected = filterType == selectedFilter
        
        backgroundColor = isSelected ? filterType.backgroundColor : .clear
        layer.borderColor = isSelected ? filterType.backgroundColor.cgColor : UIColor.grey500.cgColor // FIXME: 컬러 추가 필요
        icon.tintColor = isSelected ? .grey900 : Color.Icon.secondary // FIXME: 컬러 추가 필요
        label.textColor = isSelected ? Color.Text.inverse : Color.Text.secondary
    }
    
    private func updateDisplayStyle(_ data: any BaseEntity) {
        if let status = data as? TodoStatus {
            backgroundColor = status.backgroundColor
            icon.image = status.image?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = .grey900 // FIXME: 컬러 추가 필요
            label.text = status.text
            label.textColor = Color.Text.inverse
            
            stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0); $0.removeFromSuperview() }
            
            let views = icon.image == nil ? [label] : [icon, label]
            views.forEach { stackView.addArrangedSubview($0) }
        }
    }
}
