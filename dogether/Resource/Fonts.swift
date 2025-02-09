//
//  Fonts.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import UIKit

enum Fonts {
    static func black(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Black", size: size) ?? UIFont.systemFont(ofSize: size, weight: .black)
    }
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    static func extraBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-ExtraBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .heavy)
    }
    static func extraLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-ExtraLight", size: size) ?? UIFont.systemFont(ofSize: size, weight: .ultraLight)
    }
    static func light(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Light", size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
    }
    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Mideum", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    static func semiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    static func thin(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Thin", size: size) ?? UIFont.systemFont(ofSize: size, weight: .thin)
    }
    
    static let emphasisB = Fonts.bold(size: 28)
    static let head1B = Fonts.bold(size: 24)
    static let head2B = Fonts.bold(size: 18)
    static let body1B = Fonts.bold(size: 16)
    
    static let body1S = Fonts.semiBold(size: 16)
    static let body2S = Fonts.semiBold(size: 14)
    static let smallS = Fonts.semiBold(size: 12)
    
    static let head1R = Fonts.regular(size: 24)
    static let body1R = Fonts.regular(size: 16)
    static let body2R = Fonts.regular(size: 14)
    static let smallR = Fonts.regular(size: 12)
}
