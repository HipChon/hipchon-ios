//
//  EditProfileViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxCocoa
import RxSwift
import SwiftKeychainWrapper

class EditProfileViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let profileImageURL: Driver<URL>
    let orgName: Driver<String>
    let setChangedImage: Signal<UIImage>
    let completeButtonValid: Driver<Bool>
    let completeButtonActivity: Driver<Bool>
    let pushMainVC: Signal<Void>
    let editComplete: Signal<Void>

    // MARK: view -> viewModel

    let newName = PublishRelay<String>()
    let changedImage = BehaviorSubject<UIImage?>(value: nil)
    let completeButtonTapped = PublishRelay<Void>()

    init(_ data: AuthModel?) {

        // MARK: 공통
        
        let isSignup = BehaviorSubject<Bool>(value: data != nil)
        let authModel = BehaviorSubject<AuthModel?>(value: data)
        let activity = PublishSubject<Bool>()
        
        // profile image
        profileImageURL = isSignup
            .filter { $0 == false }
            .flatMap { _ in Singleton.shared.currentUser }
            .compactMap { $0.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())
        
        setChangedImage = changedImage
            .compactMap { $0 }
            .asSignal(onErrorSignalWith: .empty())

        // name
        
        orgName = Observable.merge(
            authModel.map { $0?.name ?? "" }, // TODO: 소셜에서 받아와야함
            isSignup.filter { $0 == false }.flatMap { _ in Singleton.shared.currentUser }.compactMap { $0.name }
        )
        .asDriver(onErrorJustReturn: "")

        completeButtonValid = Observable.merge(
            orgName.asObservable(),
            newName.asObservable()
        )
            .map { $0.count >= 3 }
            .asDriver(onErrorJustReturn: false)

        completeButtonActivity = activity
            .asDriver(onErrorJustReturn: false)
        
        // MARK: 회원가입
        
        let signupComplete = PublishSubject<Void>()
        let signinComplete = PublishSubject<Void>()
        
        completeButtonTapped
            .do(onNext: { activity.onNext(true) })
            .withLatestFrom(isSignup)
            .filter { $0 == true }
            .withLatestFrom(Observable.combineLatest(authModel, changedImage, newName))
            .compactMap { auth, image, name in
                auth?.profileImage = image
                auth?.name = name
                return auth
            }
            .flatMap { AuthAPI.shared.signup(authModel: $0) }
            .do(onNext: { _ in activity.onNext(false) })
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    signupComplete.onNext(())
                case .failure(let error):
                    switch error.statusCode {
                    case 401:
                        return
                    default:
                        break
                    }
                }
            })
            .disposed(by: bag)
                
        signupComplete
            .withLatestFrom(authModel)
            .compactMap { $0 }
            .flatMap { AuthAPI.shared.signin(authModel: $0) }
            .subscribe(onNext: { result in
                switch result {
                case let .success(data): // 가입된 유저: 로그인
                    Singleton.shared.currentUser.onNext(data)
                    signinComplete.onNext(())
                case .failure(let error): // 가입안된 유저: 회원가입
                    switch error.statusCode {
                    case 401:
                        Singleton.shared.unauthorized.onNext(())
                    default:
                        Singleton.shared.unauthorized.onNext(())
                    }
                }
            })
            .disposed(by: bag)

        // MARK: 프로필 편집
                
        let putProfileComplete = PublishSubject<Void>()
        let userRefresh = PublishSubject<Void>()
        
        completeButtonTapped
            .do(onNext: { activity.onNext(true) })
            .withLatestFrom(isSignup)
            .filter { $0 == false }
            .withLatestFrom(Observable.combineLatest(newName, changedImage))
            .flatMap { AuthAPI.shared.putProfileImage(name: $0, image: $1) }
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    userRefresh.onNext(())
                case let .failure(error):
                    activity.onNext(false)
                    switch error.statusCode{
                    case 401:
                        Singleton.shared.unauthorized.onNext(())
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)

        userRefresh
            .filter { _ in DeviceManager.shared.networkStatus }
            .flatMap { AuthAPI.shared.getUser() }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in activity.onNext(false) })
            .subscribe(onNext: { result in
                switch result {
                case let .success(data): // 가입된 유저: 로그인
                    Singleton.shared.currentUser.onNext(data)
                    putProfileComplete.onNext(())
                case .failure(let error): // 가입안된 유저: 회원가입
                    switch error.statusCode {
                    case 13: // timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)


        // MARK: scene
        
        pushMainVC = signinComplete
            .asSignal(onErrorJustReturn: ())

        editComplete = putProfileComplete
            .asSignal(onErrorJustReturn: ())

    }
}
