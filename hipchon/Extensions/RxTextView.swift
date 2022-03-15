//
//  RxTextView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxSwift

extension Reactive where Base: UITextView {
    var firstEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.text = ""
            base.textColor = .black
        }
    }
}
