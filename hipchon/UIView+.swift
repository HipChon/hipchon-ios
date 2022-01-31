//
//  UIView+.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import UIKit

extension UIView {
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.35, radius: CGFloat = 3.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}
