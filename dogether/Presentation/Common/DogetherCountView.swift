//
//  DogetherCountView.swift
//  dogether
//
//  Created by seungyooooong on 2/10/25.
//

import Foundation
import UIKit

final class DogetherCountView: UIView {
    let min: Int
    let max: Int
    var current: Int
    let unit: String
    
    init(min: Int = 2, max: Int = 10, current: Int, unit: String) {
        self.min = min
        self.max = max
        self.current = current
        self.unit = unit
        
        super.init(frame: .zero)
        setUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let dogetherCountView = {
        let view = UIView()
        view.backgroundColor = .grey50
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let minusButton = {
        let button = UIButton()
        button.setImage(.minusButton, for: .normal)
        button.tag = Directions.minus.tag
        return button
    }()
    
    private let plusButton = {
        let button = UIButton()
        button.setImage(.plusButton, for: .normal)
        button.tag = Directions.plus.tag
        return button
    }()
    
    private var currentLabel = {
        let label = UILabel()
        label.textColor = .grey900
        label.font = Fonts.body1S
        return label
    }()
    
    private let minLabel = {
        let label = UILabel()
        label.textColor = .grey500
        label.font = Fonts.body2S
        return label
    }()
    
    private let maxLabel = {
        let label = UILabel()
        label.textColor = .grey500
        label.font = Fonts.body2S
        return label
    }()
    
    private func setUI() {
        [dogetherCountView, minLabel, maxLabel].forEach { addSubview($0) }
        [minusButton, plusButton, currentLabel].forEach { dogetherCountView.addSubview($0) }
        
        dogetherCountView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        minusButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(5)
            $0.width.height.equalTo(40)
        }
        
        plusButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(-5)
            $0.width.height.equalTo(40)
        }
        
        currentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        minLabel.snp.makeConstraints {
            $0.top.equalTo(dogetherCountView.snp.bottom).offset(8)
            $0.left.equalToSuperview()
        }
        
        maxLabel.snp.makeConstraints {
            $0.top.equalTo(dogetherCountView.snp.bottom).offset(8)
            $0.right.equalToSuperview()
        }
        
        minusButton.addTarget(self, action: #selector(didTapCountButton(_:)), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapCountButton(_:)), for: .touchUpInside)
        currentLabel.text = "\(current)\(unit)"
        minLabel.text = "\(min)\(unit)"
        maxLabel.text = "\(max)\(unit)"
    }
    
    @objc private func didTapCountButton(_ sender: UIButton) {
        let after = current + sender.tag
        if min <= after && after <= max {
            current = after
            updateUI()
        }
    }
    
    private func updateUI() {
        currentLabel.text = "\(current)\(unit)"
    }
}

// TODO: 추후 Domain - Entity로 이동
enum Directions {
    case minus
    case plus
    
    var tag: Int {
        switch self {
        case .minus:
            return -1
        case .plus:
            return 1
        }
    }
}
