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
    let pushMainVC: Signal<Void>
    let editComplete: Signal<Void>

    // MARK: view -> viewModel
    let changedImage = PublishSubject<UIImage>()
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
            .asSignal(onErrorSignalWith: .empty())
        
        let signupComplete = PublishSubject<Void>()
        let putProfileComplete = PublishSubject<Void>()
        
        pushMainVC = signupComplete
            .asSignal(onErrorJustReturn: ())
        
        editComplete = putProfileComplete
            .asSignal(onErrorJustReturn: ())
        
        completeButtonTapped
            .withLatestFrom(isSignup)
            .filter { $0 == true }
            .withLatestFrom(Observable.combineLatest(authModel, changedImage))
            .compactMap { auth, image in
                auth?.profileImage = image
                return auth
            }
            .flatMap { AuthManager.shared.signup(auth: $0) }
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    signupComplete.onNext(())
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: bag)
        
        completeButtonTapped
            .withLatestFrom(isSignup)
            .filter { $0 == false }
            .withLatestFrom(changedImage)
            .flatMap { AuthManager.shared.putProfileImage(image: $0) }
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    putProfileComplete.onNext(())
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: bag)
        
    }
}
