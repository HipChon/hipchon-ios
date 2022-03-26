//
//  Singleton.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/24.
//

import RxCocoa
import RxSwift
import Toast_Swift

class Singleton {
    public static let shared = Singleton()
    private let bag = DisposeBag()

    let currentUser = BehaviorSubject<UserModel>(value: UserModel())
    
    let myPlaceRefresh = PublishSubject<Void>()
    let myReviewRefresh = PublishSubject<Void>()
    let likedReviewRefresh = PublishSubject<Void>()
    let myCommentRefresh = PublishSubject<Void>()

    let toastAlert = PublishSubject<String>()
    let unauthorized = PublishSubject<Void>()
    let unknownedError = PublishSubject<APIError>()

    private init() {
        toastAlert
            .throttle(.seconds(4), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { text in
                guard let topVC = UIApplication.topViewController() else { return }
                var style = ToastStyle()
                style.messageColor = .white
                style.backgroundColor = .black
                topVC.view.makeToast(text, duration: 3.0, position: .top, style: style)
            })
            .disposed(by: bag)

        
        unauthorized
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                guard let topVC = UIApplication.topViewController() else { return }
                let unauthorizedAlertVC = UnauthorizedAlertViewController()
                unauthorizedAlertVC.bind()
                unauthorizedAlertVC.providesPresentationContextTransitionStyle = true
                unauthorizedAlertVC.definesPresentationContext = true
                unauthorizedAlertVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                unauthorizedAlertVC.view.backgroundColor = UIColor(white: 0.4, alpha: 0.3)
                topVC.present(unauthorizedAlertVC, animated: true, completion: nil)
            })
            .disposed(by: bag)

        unknownedError
            .throttle(.seconds(4), scheduler: MainScheduler.instance)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { error in
                // TODO: 
            })
            .disposed(by: bag)
    }
}
