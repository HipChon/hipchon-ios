//
//  UITextField+.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import UIKit

extension UITextField {
    enum HorizontalLocation {
        case left
        case right
    }

    func addPadding(location: HorizontalLocation, width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: frame.height))
        switch location {
        case .left:
            leftView = paddingView
            leftViewMode = ViewMode.always
        case .right:
            rightView = paddingView
            rightViewMode = ViewMode.always
        }
    }
}
