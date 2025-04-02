//
//  BasePopupView.swift
//  dogether
//
//  Created by seungyooooong on 3/22/25.
//

import UIKit

class BasePopupView: UIView {
    weak var delegate: PopupDelegate?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        backgroundColor = .grey700
        layer.cornerRadius = 12
    }
    required init?(coder: NSCoder) { fatalError() }    
}
