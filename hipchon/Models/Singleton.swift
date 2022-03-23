//
//  Singleton.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/24.
//

import RxCocoa
import RxSwift
import Toast_Swift

class Singleton {
    public static let shred = Singleton()
    private let bag = DisposeBag()

    let userRefresh = PublishSubject<Void>()

    let toastAlert = PublishSubject<String>()

    private init() {
        toastAlert
            .throttle(.seconds(4), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { text in
                guard let topVC = UIApplication.topViewController() else { return }
                var style = ToastStyle()
                style.messageColor = .white
                style.backgroundColor = .black
                topVC.view.makeToast(text, duration: 3.0, position: .top, style: style)
            })
            .disposed(by: bag)
    }
}
