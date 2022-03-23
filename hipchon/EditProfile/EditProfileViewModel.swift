//
//  EditProfileViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxCocoa
import RxSwift

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
        let isSignup = BehaviorSubject<Bool>(value: data != nil)
        let authModel = BehaviorSubject<AuthModel?>(value: data)

        profileImageURL = isSignup
            .filter { $0 == false }
            .flatMap { _ in UserModel.currentUser }
            .compactMap { $0.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        name = Observable.merge(
            isSignup.filter { $0 == true }.flatMap { _ in authModel }.compactMap { $0?.name },
            isSignup.filter { $0 == false }.flatMap { _ in UserModel.currentUser }.compactMap { $0.name }
        )
        .asDriver(onErrorJustReturn: "")

        setChangedImage = changedImage
            .compactMap { $0 }
            .asSignal(onErrorSignalWith: .empty())

        completeButtonValid = inputNickName
            .map { $0.count >= 3 }
            .asDriver(onErrorJustReturn: false)

        let activity = PublishSubject<Bool>()

        completeButtonActivity = activity
            .asDriver(onErrorJustReturn: false)

        let signupComplete = PublishSubject<Void>()
        let putProfileComplete = PublishSubject<Void>()

        pushMainVC = signupComplete
            .asSignal(onErrorJustReturn: ())

        editComplete = putProfileComplete
            .asSignal(onErrorJustReturn: ())

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
            .flatMap { AuthManager.shared.signup(auth: $0) }
            .do(onNext: { _ in activity.onNext(false) })
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    signupComplete.onNext(())
                case let .failure(error):
                    print(error)
                }
            })
            .disposed(by: bag)

        completeButtonTapped
            .do(onNext: { activity.onNext(true) })
            .withLatestFrom(isSignup)
            .filter { $0 == false }
            .withLatestFrom(Observable.combineLatest(inputNickName, changedImage))
            .flatMap { AuthManager.shared.putProfileImage(name: $0, image: $1) }
            .do(onNext: { _ in activity.onNext(false) })
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    putProfileComplete.onNext(())
                case let .failure(error):
                    print(error)
                }
            })
            .disposed(by: bag)
    }
}
