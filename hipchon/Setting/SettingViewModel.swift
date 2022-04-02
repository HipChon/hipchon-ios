//
//  SettingViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import RxCocoa
import RxSwift
import SwiftKeychainWrapper

class SettingViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let logoutPopToOnBoarding: Signal<Void>
    let withdrawPopToOnBoarding: Signal<Void>
    let openURL: Signal<URL>

    // MARK: view -> viewModel

    let logoutButtonTapped = PublishRelay<Void>()
    let withdrawButtonTapped = PublishRelay<Void>()
    let partnershipButtonTapped = PublishRelay<Void>()
    let customerServiceButtonTapped = PublishRelay<Void>()

    init() {
        let logoutComplete = PublishSubject<Void>()
        let withdrawComplete = PublishSubject<Void>()

        logoutPopToOnBoarding = logoutComplete
            .asSignal(onErrorJustReturn: ())

        withdrawPopToOnBoarding = withdrawComplete
            .asSignal(onErrorJustReturn: ())

        logoutButtonTapped
            .subscribe(onNext: {
                Singleton.shared.removeUserInfo()
                logoutComplete.onNext(())
            })
            .disposed(by: bag)

        withdrawButtonTapped
            .flatMap { AuthAPI.shared.withdraw() }
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    Singleton.shared.removeUserInfo()
                    withdrawComplete.onNext(())
                case let .failure(error):
                    switch error.statusCode {
                    case 401:
                        Singleton.shared.unauthorized.onNext(())
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)
        
        openURL = Observable.merge(customerServiceButtonTapped.map { _ in () },
                                   partnershipButtonTapped.map { _ in () })
            .map { "http://pf.kakao.com/_xgHYNb/chat" }
            .compactMap { URL(string: $0) }
            .asSharedSequence(onErrorDriveWith: .empty())
    }
}
