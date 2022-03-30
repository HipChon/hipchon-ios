//
//  PlaceDetailViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import NMapsMap
import RxCocoa
import RxSwift

class PlaceDetailViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let placeDesVM = PlaceDesViewModel()
    let placeMapVM = PlaceMapViewModel()
    let menuListVM: Signal<MenuListViewModel>
    let reviewKeywordListVM: Signal<ReviewKeywordListViewModel>
    let reviewCellVms: Driver<[ReviewCellViewModel]>
    let pushReviewListVC: Signal<ReviewListViewModel>

    // MARK: viewModel -> view

    let urls: Driver<[URL]>
    let openURL: Signal<URL>
    let share: Signal<String>
    let menuListViewHidden: Driver<Bool>
    let reviewTableViewHidden: Driver<Bool>
    let pushReviewDetailVC: Signal<ReviewDetailViewModel>
    let pushPostReviewVC: Signal<PostReviewViewModel>

    // MARK: view -> viewModel

    let selectedReviewIdx = PublishSubject<Int>()
    let moreReviewButtonTapped = PublishRelay<Void>()
    let postReviewButtonTapped = PublishRelay<Void>()

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)
        let reviews = BehaviorSubject<[ReviewModel]>(value: [])

        // MARK: subViewModels

        placeMapVM
            .copyButtonTapped
            .withLatestFrom(place)
            .compactMap { $0.address }
            .subscribe(onNext: {
                UIPasteboard.general.string = $0
                Singleton.shared.toastAlert.onNext("클립보드에 복사되었습니다")
            })
            .disposed(by: bag)

        reviewCellVms = reviews
            .map { $0.map { ReviewCellViewModel(BehaviorSubject<ReviewModel>(value: $0)) } }
            .asDriver(onErrorJustReturn: [])

        // MARK: data

        urls = place
            .compactMap { $0.imageURLs?.compactMap { URL(string: $0) } }
            .asDriver(onErrorJustReturn: [])

        place
            .compactMap { $0.name }
            .bind(to: placeDesVM.placeName)
            .disposed(by: bag)

        place
            .map { $0.reviewCount ?? 0 }
            .bind(to: placeDesVM.reviewCount)
            .disposed(by: bag)

        place
            .compactMap { $0.sector }
            .bind(to: placeDesVM.sector)
            .disposed(by: bag)

        place
            .compactMap { $0.businessHours }
            .bind(to: placeDesVM.businessHours)
            .disposed(by: bag)

        place
            .compactMap { $0.description }
            .bind(to: placeDesVM.description)
            .disposed(by: bag)

        place
            .compactMap { $0.link }
            .bind(to: placeDesVM.link)
            .disposed(by: bag)

        place
            .compactMap { $0.address }
            .bind(to: placeMapVM.address)
            .disposed(by: bag)

        place
            .compactMap { $0.nmgLatLng }
            .bind(to: placeMapVM.nmgLatLng)
            .disposed(by: bag)

        place
            .take(1)
            .compactMap { $0.id }
            .filter {_ in DeviceManager.shared.networkStatus }
            .flatMap { PlaceAPI.shared.getPlaceDetail($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    place.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 404: // 404: Not Found(등록된 리뷰 없음)
//                        reviews.onNext([])
                        break
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)

        // MARK: bookmark

        let bookmarked = BehaviorSubject<Bool>(value: data.bookmarkYn ?? false)
        let bookmarkCount = BehaviorSubject<Int>(value: data.bookmarkCount ?? 0)

        bookmarked
            .bind(to: placeDesVM.bookmarkYn)
            .disposed(by: bag)

        bookmarkCount
            .bind(to: placeDesVM.bookmarkCount)
            .disposed(by: bag)

        let addBookmark = PublishSubject<Void>()
        let deleteBookmark = PublishSubject<Void>()

        placeDesVM.bookmarkButtonTapped
            .withLatestFrom(bookmarked)
            .subscribe(onNext: {
                $0 ? deleteBookmark.onNext(()) : addBookmark.onNext(())
            })
            .disposed(by: bag)

        addBookmark
            .withLatestFrom(bookmarkCount)
            .do(onNext: {
                bookmarked.onNext(true)
                bookmarkCount.onNext($0 + 1)
            })
            .withLatestFrom(place)
            .compactMap { $0.id }
            .flatMap { NetworkManager.shared.addBookmark($0) }
            .subscribe(onNext: {
                if $0 == true {
                    // reload
                }
            })
            .disposed(by: bag)

        deleteBookmark
            .withLatestFrom(bookmarkCount)
            .do(onNext: {
                bookmarked.onNext(false)
                bookmarkCount.onNext($0 - 1)
            })
            .withLatestFrom(place)
            .compactMap { $0.id }
            .flatMap { NetworkManager.shared.deleteBookmark($0) }
            .subscribe(onNext: {
                if $0 == true {
                    // reload
                }
            })
            .disposed(by: bag)

        menuListViewHidden = place
            .map { $0.menus?.count ?? 0 }
            .map { $0 == 0 }
            .asDriver(onErrorJustReturn: true)

        reviewTableViewHidden = reviews
            .map { $0.count == 0 }
            .asDriver(onErrorJustReturn: true)

        menuListVM = place
            .compactMap { $0.menus }
            .map { MenuListViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        reviewKeywordListVM = place
            .compactMap { $0.keywords }
            .map { ReviewKeywordListViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        openURL = Observable.merge(
            placeDesVM.linkButtonTapped
                .withLatestFrom(place)
                .compactMap { $0.link },
            placeDesVM.callButtonTapped
                .withLatestFrom(place)
                .compactMap { $0.number }
                .map { "tel://" + $0 }
        )
        .compactMap { URL(string: $0) }
        .asSignal(onErrorSignalWith: .empty())

        share = placeDesVM.share

        pushPostReviewVC = Observable.merge(placeDesVM.reviewButtonTapped.asObservable(),
                                            postReviewButtonTapped.asObservable())
            .withLatestFrom(place)
            .map { PostReviewViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        pushReviewDetailVC = selectedReviewIdx
            .withLatestFrom(reviews) { $1[$0] }
            .map { ReviewDetailViewModel(BehaviorSubject<ReviewModel>(value: $0)) }
            .asSignal(onErrorSignalWith: .empty())

        pushReviewListVC = moreReviewButtonTapped
            .withLatestFrom(place)
            .map { ReviewListViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        // MARK: API

        place
            .compactMap { $0.id }
            .filter {_ in DeviceManager.shared.networkStatus }
            .flatMap { ReviewAPI.shared.getPlaceReview($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    reviews.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 404: // 404: Not Found(등록된 리뷰 없음)
                        reviews.onNext([])
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)
    }
}
