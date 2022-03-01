//
//  Font.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/01.
//

import UIKit

enum FontType { case regular, bold, medium, light, semibold }

extension UIFont {
    static func GmarketSans(type: FontType, size: CGFloat) -> UIFont {
        var fontName = ""
        switch type {
            case .medium:
            fontName = "GmarketSansTTFMedium"
            case .bold:
            fontName = "GmarketSansTTFBold"
            default:
            fontName = "GmarketSansTTFMedium"
        }
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func AppleSDGothicNeo(type: FontType, size: CGFloat) -> UIFont {
        var fontName = ""
        switch type {
            case .regular:
            fontName = "AppleSDGothicNeo-Regular"
            case .light:
            fontName = "AppleSDGothicNeo-Light"
            case .medium:
            fontName = "AppleSDGothicNeo-Medium"
            case .semibold:
            fontName = "AppleSDGothicNeo-SemiBold"
            case .bold:
            fontName = "AppleSDGothicNeo-Bold"
        }
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

