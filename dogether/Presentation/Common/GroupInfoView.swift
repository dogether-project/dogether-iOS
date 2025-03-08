//
//  GroupInfoView.swift
//  dogether
//
//  Created by seungyooooong on 3/8/25.
//

import Foundation
import UIKit

final class GroupInfoView: UIView {
    private(set) var groupInfo: GroupInfo
    
    init(groupInfo: GroupInfo = GroupInfo()) {
        self.groupInfo = groupInfo
        
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private let nameLabel = UILabel()
    
    func descriptionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: text,
            attributes: Fonts.getAttributes(for: Fonts.body2S, textAlignment: .left)
        )
        label.textColor = .grey300
        return label
    }
    
    final class InfoLabel: UILabel {
        private(set) var infoText: String = ""
        
        init() {
            super.init(frame: .zero)
            setUI()
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        private func updateUI() {
            attributedText = NSAttributedString(
                string: infoText,
                attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
            )
        }
        
        private func setUI() {
            updateUI()
            
            textColor = .grey0
        }
        
        func updateText(_ text: String) {
            self.infoText = text
            
            updateUI()
        }
    }
    private let durationInfoLabel = InfoLabel()
    private let joinCodeInfoLabel = InfoLabel()
    private let endDateInfoLabel = InfoLabel()
    
    
    private func infoStackView(labels: [UILabel]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .vertical
        return stackView
    }
    
    private func updateUI() {
        nameLabel.text = groupInfo.name
        
        durationInfoLabel.updateText("\(groupInfo.duration)일")
        joinCodeInfoLabel.updateText(groupInfo.joinCode)
        endDateInfoLabel.updateText("\(groupInfo.endAt)(D-\(groupInfo.remainingDays))")
    }
    
    private func setUI() {
        updateUI()
        
        nameLabel.textColor = .blue300
        nameLabel.font = Fonts.emphasis2B
        
        let durationDescriptionLabel = descriptionLabel(text: "총 기간")
        let joinCodeDescriptionLabel = descriptionLabel(text: "초대코드")
        let endDateDescriptionLabel = descriptionLabel(text: "종료일")
        
        let durationStackView = infoStackView(labels: [durationDescriptionLabel, durationInfoLabel])
        let joinCodeStackView = infoStackView(labels: [joinCodeDescriptionLabel, joinCodeInfoLabel])
        let endDateStackView = infoStackView(labels: [endDateDescriptionLabel, endDateInfoLabel])
        
        let groupInfoStackView = UIStackView(arrangedSubviews: [durationStackView, joinCodeStackView, endDateStackView])
        groupInfoStackView.axis = .horizontal
        groupInfoStackView.spacing = 28
        
        [nameLabel, groupInfoStackView].forEach { self.addSubview($0) }
        
        nameLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        groupInfoStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview()
        }
    }
    
    func setGroupInfo(groupInfo: GroupInfo) {
        self.groupInfo = groupInfo
        
        updateUI()
    }
}
