//
//  StartViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/22.
//

import RxCocoa
import RxRelay
import RxSwift

class StartViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let pushRegisterVC: Signal<RegisterViewModel>
    let pushLoginVC: Signal<LoginViewModel>

    // MARK: view -> viewModel

    let loginButtonTapped = PublishRelay<Void>()
    let registerButtonTapped = PublishRelay<Void>()

    init() {
        pushRegisterVC = registerButtonTapped
            .map { RegisterViewModel() }
            .asSignal(onErrorSignalWith: .empty())

        pushLoginVC = loginButtonTapped
            .map { LoginViewModel() }
            .asSignal(onErrorSignalWith: .empty())
    }
}
