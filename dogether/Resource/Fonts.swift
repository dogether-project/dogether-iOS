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
}
