//
//  UIColor+.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/01.
//

import Foundation
import UIKit

extension UIColor {
    static var primary_green: UIColor { return UIColor(hexString: "#3FCC53")! }
    static var secondary_yellow: UIColor { return UIColor(hexString: "#FFDF40")! }
    static var secondary_red: UIColor { return UIColor(hexString: "#FF4A4A")! }
    static var secondary_blue: UIColor { return UIColor(hexString: "#00C9FF")! }
    static var gray01: UIColor { return UIColor(hexString: "#F0F1F5")! }
    static var gray02: UIColor { return UIColor(hexString: "#E4E5EB")! }
    static var gray03: UIColor { return UIColor(hexString: "#D1D2D7")! }
    static var gray04: UIColor { return UIColor(hexString: "#9B9CA4")! }
    static var gray05: UIColor { return UIColor(hexString: "#6C6E78")! }
    static var gray06: UIColor { return UIColor(hexString: "#484950")! }
    static var gray07: UIColor { return UIColor(hexString: "#36373C")! }
    static var gray_inside: UIColor { return UIColor(hexString: "#F8F8FA")! }
    static var gray_background: UIColor { return UIColor(hexString: "#F5F5F5")! }
    static var gray_border: UIColor { return UIColor(hexString: "#E4E5EB")! }
    static var typography_secondary: UIColor { return UIColor(hexString: "#6C6E78")! }

    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }

    convenience init(red: Double, green: Double, blue: Double, a: Double = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }

    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars = ["F", "F"] + chars
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2 ... 3]), nil, 16)) / 255,
                  green: .init(strtoul(String(chars[4 ... 5]), nil, 16)) / 255,
                  blue: .init(strtoul(String(chars[6 ... 7]), nil, 16)) / 255,
                  alpha: .init(strtoul(String(chars[0 ... 1]), nil, 16)) / 255)
    }
}
