////
////  BottomSheetViewController.swift
////  dogether
////
////  Created by yujaehong on 4/28/25.
////
//
//import UIKit
//
protocol BottomSheetItemRepresentable {
    var bottomSheetItem: BottomSheetItem { get }
}

struct BottomSheetItem: Hashable {
    let displayName: String
    let value: AnyHashable
}
