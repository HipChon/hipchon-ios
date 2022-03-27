//
//  CustomerServiceViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/01.
//

import RxRelay
import RxSwift

class CustomerServiceViewModel {
    private let bag = DisposeBag()

    let counselingButtonTapped = PublishRelay<Void>()
    let placeRegisterButtonTapped = PublishRelay<Void>()

    let selectedURLStr = PublishSubject<String>()

    init() {
        Observable.merge(
            counselingButtonTapped.asObservable(),
            placeRegisterButtonTapped.asObservable()
        )
        .map { _ in "http://pf.kakao.com/_xgHYNb/chat" }
        .bind(to: selectedURLStr)
        .disposed(by: bag)
    }
}
