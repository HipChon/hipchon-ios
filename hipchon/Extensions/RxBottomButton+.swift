//
//  RxBottomButton+.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/23.
//

import RxSwift

extension Reactive where Base: BottomButton {
    var activityIndicator: Binder<Bool> {
        return Binder(base) { base, valid in
            valid ? base.showLoading() : base.hideLoading()
        }
    }
}
