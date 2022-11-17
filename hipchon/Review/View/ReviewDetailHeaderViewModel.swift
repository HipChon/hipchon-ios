//
//  ReviewDetailHeaderViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/30.
//

import RxCocoa
import RxSwift

class ReviewDetailHeaderViewModel {
    private let bag = DisposeBag()

    // MARK: subviewModels

    let reviewPlaceVM: Driver<ReviewPlaceViewModel>

    // MARK: viewModel -> view

    let placeName: Driver<String>
    let profileImageURL: Driver<URL>
    let userName: Driver<String>
    let userReviewCount: Driver<Int>
    let postDate: Driver<String>
    let reviewImageURLs: Driver<[URL]>
    let reviewImageHidden: Driver<Bool>
    let likeYn: Driver<Bool>
    let likeCount: Driver<Int>
    let commentCount: Driver<Int>
    let content: Driver<String>
    let pushPlaceDetailVC: Signal<PlaceDetailViewModel>
    let share: Signal<String>
    let reportButtonHidden: Driver<Bool>

    // MARK: view -> viewModel

    let likeButtonTapped = PublishRelay<Void>()
    let reportButtonTapped = PublishRelay<Void>()

    init(_ review: BehaviorSubject<Review>) {
//        let review = BehaviorSubject<ReviewModel>(value: data)

        reviewPlaceVM = review
            .compactMap { $0.place }
            .map { BehaviorSubject<Place>(value: $0) }
            .map { ReviewPlaceViewModel($0) }
            .asDriver(onErrorDriveWith: .empty())

        placeName = review
            .compactMap { $0.place?.name }
            .asDriver(onErrorJustReturn: "")

        profileImageURL = review
            .compactMap { $0.user?.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        userName = review
            .compactMap { $0.user?.name }
            .asDriver(onErrorJustReturn: "")

        userReviewCount = review
            .compactMap { $0.user?.reviewCount }
            .asDriver(onErrorJustReturn: 0)

        postDate = review
            .compactMap { $0.formattedPostDate }
            .asDriver(onErrorJustReturn: "")

        reviewImageURLs = review
            .compactMap { $0.imageURLs?.compactMap { URL(string: $0 ?? "") } }
            .asDriver(onErrorJustReturn: [])
        
        reviewImageHidden = review
            .map { $0.imageURLs?.count == 0 }
            .asDriver(onErrorJustReturn: false)

        commentCount = review
            .compactMap { $0.commentCount }
            .asDriver(onErrorJustReturn: 0)

        content = review
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")

        // MARK: like

        let liked = BehaviorSubject<Bool>(value: false)
        let likeCounted = BehaviorSubject<Int>(value: 0)
        let addLike = PublishSubject<Void>()
        let deleteLike = PublishSubject<Void>()

        review
            .compactMap { $0.likeYn }
            .bind(to: liked)
            .disposed(by: bag)

        review
            .compactMap { $0.likeCount }
            .bind(to: likeCounted)
            .disposed(by: bag)

        likeYn = liked
            .asDriver(onErrorJustReturn: false)

        likeCount = likeCounted
            .asDriver(onErrorJustReturn: 0)

        likeButtonTapped
            .withLatestFrom(liked)
            .subscribe(onNext: {
                $0 ? deleteLike.onNext(()) : addLike.onNext(())
            })
            .disposed(by: bag)

        addLike
            .filter { DeviceManager.shared.networkStatus }
            .withLatestFrom(review)
            .compactMap {
                $0.likeYn = true
                $0.likeCount = ($0.likeCount ?? 0) + 1
                review.onNext($0)
                return $0.id
            }
            .flatMap { ReviewAPI.shared.addLike($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
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

        deleteLike
            .filter { DeviceManager.shared.networkStatus }
            .withLatestFrom(review)
            .compactMap {
                $0.likeYn = false
                $0.likeCount = ($0.likeCount ?? 0) - 1
                review.onNext($0)
                return $0.id
            }
            .flatMap { ReviewAPI.shared.deleteLike($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
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

        // MARK: scene

        pushPlaceDetailVC = reviewPlaceVM
            .flatMap { $0.pushPlaceDetailVC }

        share = reviewPlaceVM.flatMap { $0.share }

        reportButtonTapped
            .withLatestFrom(review)
            .subscribe(onNext: {
                var userBlockArr = UserDefaults.standard.value(forKey: "userBlock") as? [Int] ?? []
                var reviewBlockArr = UserDefaults.standard.value(forKey: "reviewBlock") as? [Int] ?? []
                guard let userId = $0.user?.id,
                      let reviewId = $0.id else { return }
                userBlockArr.append(userId)
                reviewBlockArr.append(reviewId)
                UserDefaults.standard.set(userBlockArr, forKey: "userBlock")
                UserDefaults.standard.set(reviewBlockArr, forKey: "reviewBlock")
                Singleton.shared.blockReviewRefresh.onNext(())
                Singleton.shared.toastAlert.onNext("게시물 신고가 완료되었습니다")
            })
            .disposed(by: bag)
        
        reportButtonHidden = Observable.combineLatest(review.compactMap { $0.user?.id },
                                                      Singleton.shared.currentUser.compactMap { $0.id })
            .map { $0 == $1 }
            .asDriver(onErrorJustReturn: false)
    }
}
