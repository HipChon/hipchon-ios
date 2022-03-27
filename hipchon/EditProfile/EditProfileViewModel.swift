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
    let name: Driver<String>
    let setChangedImage: Signal<UIImage>
    let completeButtonValid: Driver<Bool>
    let completeButtonActivity: Driver<Bool>
    let pushMainVC: Signal<Void>
    let editComplete: Signal<Void>

    // MARK: view -> viewModel

    let inputNickName = BehaviorRelay<String>(value: "")
    let changedImage = BehaviorSubject<UIImage?>(value: nil)
    let completeButtonTapped = PublishRelay<Void>()

    init(_ data: AuthModel?) {

        // MARK: 공통
        
        let isSignup = BehaviorSubject<Bool>(value: data != nil)
        let authModel = BehaviorSubject<AuthModel?>(value: data)
        let activity = PublishSubject<Bool>()
        
        setChangedImage = changedImage
            .compactMap { $0 }
            .asSignal(onErrorSignalWith: .empty())

        completeButtonValid = inputNickName
            .map { $0.count >= 3 }
            .asDriver(onErrorJustReturn: false)

        completeButtonActivity = activity
            .asDriver(onErrorJustReturn: false)
        
        // MARK: 회원가입
        
        let signupComplete = PublishSubject<Void>()
        
        completeButtonTapped
            .do(onNext: { activity.onNext(true) })
            .withLatestFrom(isSignup)
            .filter { $0 == true }
            .withLatestFrom(Observable.combineLatest(authModel, changedImage, inputNickName))
            .compactMap { auth, image, name in
                auth?.profileImage = image
                auth?.name = name
                return auth
            }
            .flatMap { AuthManager.shared.signup(authModel: $0) }
            .do(onNext: { _ in activity.onNext(false) })
            .subscribe(onNext: { result in
                switch result {
                case .success(let user):
                    guard let id = user.id else { return }
                    KeychainWrapper.standard.set(id, forKey: "accessToken")
                    Singleton.shared.currentUser.onNext(user)
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

        // MARK: 프로필 편집
                
        let putProfileComplete = PublishSubject<Void>()
        let userRefresh = PublishSubject<Void>()
        
        profileImageURL = isSignup
            .filter { $0 == false }
            .flatMap { _ in Singleton.shared.currentUser }
            .compactMap { $0.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        name = Observable.merge(
            isSignup.filter { $0 == true }.flatMap { _ in authModel }.compactMap { $0?.name }, // TODO: 소셜에서 받아와야함
            isSignup.filter { $0 == false }.flatMap { _ in Singleton.shared.currentUser }.compactMap { $0.name }
        )
        .asDriver(onErrorJustReturn: "")
        
        completeButtonTapped
            .do(onNext: { activity.onNext(true) })
            .withLatestFrom(isSignup)
            .filter { $0 == false }
            .withLatestFrom(Observable.combineLatest(inputNickName, changedImage))
            .flatMap { AuthManager.shared.putProfileImage(name: $0, image: $1) }
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    userRefresh.onNext(())
                case let .failure(error):
                    // TODO: 에러 핸들링
                    print(error)
                }
            })
            .disposed(by: bag)
        
        userRefresh
            .flatMap { NetworkManager.shared.getUser() }
            .do(onNext: { _ in activity.onNext(false) })
            .subscribe(onNext: {
                Singleton.shared.currentUser.onNext($0)
                putProfileComplete.onNext(())
            })
            .disposed(by: bag)


        // MARK: scene
        
        pushMainVC = signupComplete
            .asSignal(onErrorJustReturn: ())

        editComplete = putProfileComplete
            .asSignal(onErrorJustReturn: ())

    }
}
