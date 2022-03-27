//
//  UIScrollView+.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/19.
//

import UIKit

extension UIScrollView {
    func isNearTheBottomEdge(_ contentOffset: CGPoint) -> Bool {
        if contentSize.height == 0 { return false }
        return contentOffset.y + frame.size.height > contentSize.height
    }
}
