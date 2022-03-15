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
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        switch location {
        case .left:
            self.leftView = paddingView
            self.leftViewMode = ViewMode.always
        case .right:
            self.rightView = paddingView
            self.rightViewMode = ViewMode.always
        }
    }
}
