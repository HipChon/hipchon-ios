//
//  OnBoardingViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/22.
//

import RxCocoa
import RxRelay
import RxSwift
import SwiftKeychainWrapper

class OnBoardingViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let pushTermsVC: Signal<TermsViewModel>
    let pushMainVC: Signal<Void>

    // MARK: view -> viewModel

    let kakaoLoginButtonTapped = PublishRelay<Void>()
    let appleLoginButtonTapped = PublishRelay<Void>()
    let guestLoginButtonTapped = PublishRelay<Void>()
    let appleId = PublishSubject<String>()

    init() {
        let signupedUser = PublishSubject<Bool>()
        let login = PublishSubject<Void>()
        let authModel = BehaviorSubject<AuthModel?>(value: nil)
        let kakaoId = PublishSubject<String>()
        
//        // 자동 로그인
//        Observable.just(())
//            .delay(.seconds(3), scheduler: MainScheduler.instance)
//            .compactMap { KeychainWrapper.standard.string(forKey: "id") }
//            .map {  _ in () }
//            .bind(to: login)
//            .disposed(by: bag)
        
        // AuthModel
        
        kakaoId
            .map { AuthModel(id: $0, type: "카카오") }
            .bind(to: authModel)
            .disposed(by: bag)
        
        appleId
            .map { AuthModel(id: $0, type: "애플") }
            .bind(to: authModel)
            .disposed(by: bag)
        
        guestLoginButtonTapped
            .bind(to: login)
            .disposed(by: bag)
        
        // 카카오 로그인
        kakaoLoginButtonTapped
            .flatMap { AuthManager.shared.kakaoSignin() }
            .subscribe(onNext: { result in
                switch result {
                case .success(let id):
                    kakaoId.onNext(id)
                case let .failure(error):
                    // TODO: 에러 핸들링
                    print(error.description)
                }
            })
            .disposed(by: bag)
        
        
        // 힙촌 로그인
        
        authModel
            .compactMap { $0 }
            .flatMap { AuthManager.shared.signin(authModel: $0) }
            .subscribe(onNext: { result in
                switch result {
                case .success(let user): // 가입된 유저: 로그인
                    Singleton.shared.currentUser.onNext(user)
                    signupedUser.onNext(true)
                case .failure(let error): // 가입안된 유저: 회원가입
                    switch error.statusCode {
                    case 401:
                        signupedUser.onNext(false)
                        return
                    default:
                        break
                    }
                }
            })
            .disposed(by: bag)

        // 회원가입
        pushTermsVC = signupedUser
            .filter { $0 == false }
            .withLatestFrom(authModel)
            .compactMap { $0 }
            .map { TermsViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        signupedUser
            .filter { $0 == true }
            .withLatestFrom(authModel)
            .compactMap { $0?.id }
            .do(onNext: { id in // 로컬에 id 저장
                KeychainWrapper.standard.set(id, forKey: "id")
            })
            .map { _ in () }
            .bind(to: login)
            .disposed(by: bag)
        
        pushMainVC = login
            .asSignal(onErrorJustReturn: ())
    }
}
