//
//  Color.swift
//  dogether
//
//  Created by yujaehong on 1/26/26.
//

import UIKit

enum Color {
    enum Background {
        static let `default` = UIColor(named: "colorBgDefault")!
        static let elavated = UIColor(named: "colorBgElavated")!
        static let surface = UIColor(named: "colorBgSurface")!
        static let disabled = UIColor(named: "colorBgDisabled")!
        static let primary = UIColor(named: "colorBgPrimary")!
        static let inverse = UIColor(named: "colorBgInverse")!
        static let dim = Color.Background.default.withAlphaComponent(0.8)
    }
    
    enum Icon {
        static let `default` = UIColor(named: "colorIconDefault")!
        static let disabled = UIColor(named: "colorIconDisabled")!
        static let elavated = UIColor(named: "colorIconElavated")!
        static let error = UIColor(named: "colorIconError")!
        static let primary = UIColor(named: "colorIconPrimary")!
        static let secondary = UIColor(named: "colorIconSecondary")!
    }
    
    enum Border {
        static let `default` = UIColor(named: "colorBorderDefault")!
        static let disabled = UIColor(named: "colorBorderDisabled")!
        static let elavated = UIColor(named: "colorBorderElavated")!
        static let error = UIColor(named: "colorBorderError")!
        static let primary = UIColor(named: "colorBorderPrimary")!
        static let secondary = UIColor(named: "colorBorderSecondary")!
    }
    
    enum Text {
        static let `default` = UIColor(named: "colorTextDefault")!
        static let subtle = UIColor(named: "colorTextSubtle")!
        static let secondary = UIColor(named: "colorTextSecondary")!
        static let disabled = UIColor(named: "colorTextDisabled")!
        static let primary = UIColor(named: "colorTextPrimary")!
        static let error = UIColor(named: "colorTextError")!
        static let inverse = UIColor(named: "colorTextInverse")!
    }
    
    enum Shadow {
        static let `default` = Color.Background.default.withAlphaComponent(0.3)
    }
}
