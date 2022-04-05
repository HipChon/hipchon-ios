//
//  RxButton+.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/23.
//

import RxSwift
import UIKit

extension Reactive where Base: UIButton {
    var image: Binder<UIImage> {
        return Binder(base) { base, image in
            base.setImage(image, for: .normal)
        }
    }

    var validUI: Binder<Bool> {
        return Binder(base) { base, valid in
            base.isEnabled = valid
            base.backgroundColor = valid ? UIColor.systemGreen : UIColor.lightGray
            base.titleLabel?.textColor = valid ? UIColor.white : UIColor.lightGray
        }
    }

    var titleColor: Binder<UIColor> {
        return Binder(base) { base, color in
            base.titleLabel?.textColor = color
        }
    }

    var setImageKF: Binder<URL> {
        return Binder(base) { base, url in
            base.kf.setImage(with: url, for: .normal, options: [.transition(.fade(0.7))])
        }
    }
}


