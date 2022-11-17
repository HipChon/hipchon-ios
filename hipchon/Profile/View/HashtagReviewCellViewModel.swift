//
//  HashtagReviewCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxCocoa
import RxSwift

class HashtagReviewCellViewModel {
    private let bag = DisposeBag()

    let imageURL: Driver<URL>
    let name: Driver<String>
    let hashtagImageURL: Driver<URL>
    let deleteEnable: Driver<Bool>

    let deleteTapped = PublishSubject<Void>()
    let showTapped = PublishSubject<Void>()

    init(review: BehaviorSubject<Review>, type: BehaviorSubject<ProfileReviewType>) {
        deleteEnable = type
            .map { $0 == .myReview }
            .asDriver(onErrorJustReturn: false)

        imageURL = review
            .compactMap { $0.topImageUrl }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        name = review
            .compactMap { $0.placeName }
            .asDriver(onErrorDriveWith: .empty())

        hashtagImageURL = review
            .compactMap { $0.place?.hashtag?.imageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        let deleteMyReview = PublishSubject<Void>()
        let deleteLike = PublishSubject<Void>()
        
        deleteTapped
            .filter { DeviceManager.shared.networkStatus }
            .do(onNext: { LoadingIndicator.showLoading() })
            .withLatestFrom(type)
            .subscribe(onNext :{
                $0 == .myReview ? deleteMyReview.onNext(()) : deleteLike.onNext(())
            })
            .disposed(by: bag)
                
        deleteMyReview
            .withLatestFrom(review)
            .compactMap { $0.id }
            .flatMap { ReviewAPI.shared.deleteReview($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in LoadingIndicator.hideLoading() })
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    Singleton.shared.myReviewRefresh.onNext(())
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 연결 상태를 확인해주세요")
                    default:
                        break
                    }
                }
            })
            .disposed(by: bag)
                
        deleteLike
            .withLatestFrom(review)
            .compactMap { $0.id }
            .flatMap { ReviewAPI.shared.deleteLike($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in LoadingIndicator.hideLoading() })
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    Singleton.shared.likedReviewRefresh.onNext(())
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 연결 상태를 확인해주세요")
                    default:
                        break
                    }
                }
            })
            .disposed(by: bag)
            

    }
}
