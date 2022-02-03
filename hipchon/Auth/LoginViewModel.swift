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
    let presentHomeViewController: Signal<HomeViewModel>

    // MARK: view -> viewModel

    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let loginButtonTapped = PublishRelay<Void>()

    init() {
        let homeViewModel = HomeViewModel()
        let loginModel = BehaviorSubject<LoginModel>(value: LoginModel())

        Observable.combineLatest(email, password)
            .compactMap { LoginModel(email: $0, password: $1) }
            .bind(to: loginModel)
            .disposed(by: bag)

        loginValid = loginModel
            .map { $0.emailValidCheck() && $0.passwordValidCheck() }
            .asDriver(onErrorJustReturn: false)

        presentHomeViewController = loginButtonTapped
            .map { _ in homeViewModel }
            .asSignal(onErrorSignalWith: .empty())
    }
}
