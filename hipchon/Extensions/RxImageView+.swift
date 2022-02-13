//
//  RxImageView+.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import Kingfisher
import RxSwift
import UIKit

extension Reactive where Base: UIImageView {
    var borderColor: Binder<CGColor> {
        return Binder(base) { base, color in
            base.layer.borderColor = color
        }
    }

    var setImageKF: Binder<URL> {
        return Binder(base) { base, url in
            base.kf.setImage(with: url, options: [.transition(.fade(0.7))])
        }
    }
}
