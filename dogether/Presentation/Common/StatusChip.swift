//
//  StatusChip.swift
//  dogether
//
//  Created by yujaehong on 2/2/26.
//

import UIKit

enum StatusChipStyle {
    case selectable   // 필터 선택용 (선택/미선택 상태)
    case display      // 상태 표시용 (단순 표시)
}

final class StatusChip: BaseButton {
    // MARK: - Delegates (selectable 스타일 전용)
    var mainDelegate: MainDelegate? {
        didSet {
            guard let filterType = filterType else { return }
            addAction(
                UIAction { [weak self] _ in
                    self?.mainDelegate?.selectFilterAction(filterType: filterType)
                }, for: .touchUpInside
            )
        }
    }

    var certificationListDelegate: CertificationListPageDelegate? {
        didSet {
            guard let filterType = filterType else { return }
            addAction(
                UIAction { [weak self] _ in
                    self?.certificationListDelegate?.selectFilterAction(filterType: filterType)
                }, for: .touchUpInside
            )
        }
    }

    private let style: StatusChipStyle
    private let filterType: FilterTypes?

    private let icon = UIImageView()
    private let label = UILabel()
    private let stackView = UIStackView()

    // MARK: - Initializers

    /// selectable 스타일용 (FilterButton 대체)
    init(filterType: FilterTypes) {
        self.style = .selectable
        self.filterType = filterType

        super.init(frame: .zero)
    }

    /// display 스타일용 (TodoStatusButton 대체)
    init() {
        self.style = .display
        self.filterType = nil

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    override func configureView() {
        layer.cornerRadius = 16

        if style == .selectable {
            layer.borderWidth = 1
        }

        icon.image = filterType?.image?.withRenderingMode(.alwaysTemplate)

        label.text = filterType?.text
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
        switch style {
        case .selectable:
            updateSelectableStyle(data)
        case .display:
            updateDisplayStyle(data)
        }
    }

    private func updateSelectableStyle(_ data: any BaseEntity) {
        guard let selectedFilter = data as? FilterTypes,
              let filterType = filterType else { return }

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

            rebuildStackView()
        }
    }

    private func rebuildStackView() {
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0); $0.removeFromSuperview() }

        let views = icon.image == nil ? [label] : [icon, label]
        views.forEach { stackView.addArrangedSubview($0) }
    }
}
