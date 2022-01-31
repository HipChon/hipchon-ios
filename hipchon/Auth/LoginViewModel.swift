//
//  LoginViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import RxCocoa
import RxRelay
import RxSwift

class LoginViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let loginValid: Driver<Bool>

    // MARK: view -> viewModel

    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")

    init() {
        let loginModel = BehaviorSubject<LoginModel>(value: LoginModel())

        Observable.combineLatest(email, password)
            .compactMap { LoginModel(email: $0, password: $1) }
            .bind(to: loginModel)
            .disposed(by: bag)

        loginValid = loginModel
            .map { $0.emailValidCheck() && $0.passwordValidCheck() }
            .asDriver(onErrorJustReturn: false)

        loginModel
            .subscribe(onNext: {
                print($0.email, $0.password)
            })
            .disposed(by: bag)
    }
}
