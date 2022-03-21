//
//  OnBoardingViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/22.
//

import RxCocoa
import RxRelay
import RxSwift

class OnBoardingViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let pushTermsVC: Signal<TermsViewModel>
    let pushMainVC: Signal<Void>

    // MARK: view -> viewModel

    let kakaoLoginButtonTapped = PublishRelay<Void>()
    let appleLoginButtonTapped = PublishRelay<Void>()
    let token = BehaviorSubject<String>(value: "")
    let email = BehaviorSubject<String>(value: "")
    let name = BehaviorSubject<String>(value: "")

    init() {
        let signupedUser = PublishSubject<Bool>()
        
        token
            .skip(1)
            .flatMap { AuthManager.shared.signin(token: $0) }
            .subscribe(onNext: { result in
                switch result {
                case .success():
                    signupedUser.onNext(true)
                case .failure(let error):
                    print(error.description)
                    signupedUser.onNext(false)
                }
            })
            .disposed(by: bag)
   
        pushTermsVC = signupedUser
            .filter { $0 == true }
            .withLatestFrom(Observable.combineLatest(token,
                                                     email,
                                                     name))
            .map { AuthModel(token: $0.0, email: $0.1, name: $0.2) }
            .map { TermsViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
        

        pushMainVC = signupedUser
            .filter { $0 == false }
            .map { _ in () }
            .asSignal(onErrorSignalWith: .empty())
        
        
        kakaoLoginButtonTapped
            .flatMap { AuthManager.shared.kakaoSignup() }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let accessToken):
                    self?.token.onNext(accessToken!)
                case .failure(let error):
                    print(error.description)
                }
            })
            .disposed(by: bag)
    }
}
