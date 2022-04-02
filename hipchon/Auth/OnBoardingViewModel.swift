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
        
        // 자동 로그인
//        Observable.just(())
////            .delay(.seconds(3), scheduler: MainScheduler.instance)
//            .compactMap { KeychainWrapper.standard.string(forKey: "accessToken") }
//            .map {  _ in () }
//            .subscribe(onNext: {
//                login.onNext(())
//            })
////            .bind(to: login)
//            .disposed(by: bag)
        
        // AuthModel
        
        Observable.merge(kakaoId.map { AuthModel(id: $0, type: "kakao") },
                         appleId.map { AuthModel(id: $0, type: "apple") })
            .bind(to: authModel)
            .disposed(by: bag)
 
        guestLoginButtonTapped
            .bind(to: login)
            .disposed(by: bag)
        
        // 카카오 로그인
        kakaoLoginButtonTapped
            .filter { DeviceManager.shared.networkStatus }
            .flatMap { AuthAPI.shared.kakaoSignin() }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let id):
                    kakaoId.onNext(id)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)
        
        // 힙촌 로그인
        
        authModel
            .compactMap { $0 } // nil filtering
            .filter { _ in DeviceManager.shared.networkStatus }
            .do(onNext: { _ in LoadingIndicator.showLoading() })
            .flatMap { AuthAPI.shared.signin(authModel: $0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in LoadingIndicator.hideLoading() })
            .subscribe(onNext: { result in
                switch result {
                case let .success(data): // 가입된 유저: 로그인
                    Singleton.shared.currentUser.onNext(data)
                    signupedUser.onNext(true)
                case .failure(let error): // 가입안된 유저: 회원가입
                    switch error.statusCode {
//                    case 401: // 401: unauthorized(토큰 만료)
//                        Singleton.shared.unauthorized.onNext(())
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        signupedUser.onNext(false)
//                        Singleton.shared.unknownedError.onNext(error)
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
                KeychainWrapper.standard.set(id, forKey: "accessToken")
            })
            .map { _ in () }
            .subscribe(onNext: {
                login.onNext(())
            })
            .disposed(by: bag)
        
        pushMainVC = login
            .asSignal(onErrorJustReturn: ())
    }
}
