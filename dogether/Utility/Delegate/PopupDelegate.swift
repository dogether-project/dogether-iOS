//
//  PopupDelegate.swift
//  dogether
//
//  Created by seungyooooong on 3/22/25.
//

import Foundation

protocol PopupDelegate: AnyObject {
    func hidePopup()
    var rejectPopupCompletion: ((String) -> Void)? { get set }
}
