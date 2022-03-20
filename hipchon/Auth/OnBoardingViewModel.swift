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

    let pushRegisterVC: Signal<RegisterViewModel>
    let pushMainVC: Signal<Void>

    // MARK: view -> viewModel

    let kakaoLoginButtonTapped = PublishRelay<Void>()
    let appleLoginButtonTapped = PublishRelay<Void>()
    let appleUserIdentifier = PublishSubject<String>()

    init() {
        let kakaoAccessToken = PublishSubject<String>()
        let signupedUser = PublishSubject<Bool>()
        
        kakaoLoginButtonTapped
            .flatMap { AuthManager.shared.kakaoSignup() }
            .subscribe(onNext: { result in
                switch result {
                case .success(let accessToken):
                    kakaoAccessToken.onNext(accessToken!)
                case .failure(let error):
                    print(error.description)
                }
            })
            .disposed(by: bag)
        
        Observable.merge(
            kakaoAccessToken,
            appleUserIdentifier
        )
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
   
        pushRegisterVC = signupedUser
            .filter { $0 == false }
            .map { _ in RegisterViewModel() }
            .asSignal(onErrorSignalWith: .empty())
        

        pushMainVC = signupedUser
            .filter { $0 == true }
            .map { _ in () }
            .asSignal(onErrorSignalWith: .empty())
        
        
    }
}
