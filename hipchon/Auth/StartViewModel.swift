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
    let pushMainVC: Signal<Void>

    // MARK: view -> viewModel

    let kakaoLoginButtonTapped = PublishRelay<Void>()
    let appleLoginButtonTapped = PublishRelay<Void>()

    init() {
        let token = PublishSubject<String?>()
        let signup = PublishSubject<Void>()
        let signinComplete = PublishSubject<Void>()
        
        kakaoLoginButtonTapped
            .map { UserDefaults.standard.value(forKey: "token") as? String }
            .bind(to: token)
            .disposed(by: bag)
        
        token
            .filter { $0 == nil }
            .flatMap { _ in AuthManager.shared.kakaoSignup() }
            .subscribe(onNext: { result in
                switch result {
                case .success(let accessToken):
                    UserDefaults.standard.set(accessToken, forKey: "token")
                    signup.onNext(())
                case .failure(let error):
                    print(error.description)
                }
            })
            .disposed(by: bag)
        
        token
            .filter { $0 != nil }
            .flatMap { AuthManager.shared.signin(token: $0!) }
            .subscribe(onNext: { result in
                switch result {
                case .success():
                    signinComplete.onNext(())
                case .failure(let error):
                    print(error.description)
                }
            })
            .disposed(by: bag)
   
        pushRegisterVC = signup
            .map { RegisterViewModel() }
            .asSignal(onErrorSignalWith: .empty())
        

        pushMainVC = signinComplete
            .map { _ in () }
            .asSignal(onErrorSignalWith: .empty())
        
        
    }
}
