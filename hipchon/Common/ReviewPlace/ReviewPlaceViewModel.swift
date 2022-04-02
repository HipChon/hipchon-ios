//
//  ReviewPlaceViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/10.
//

import RxCocoa
import RxSwift

class ReviewPlaceViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let placeName: Driver<String>
    let address: Driver<String>
    let sector: Driver<String>
    let bookmarkYn: Driver<Bool>
    let pushPlaceDetailVC: Signal<PlaceDetailViewModel>
    let share: Signal<String>

    // MARK: view -> viewModel

    let insideButtonTapped = PublishRelay<Void>()
    let bookmarkButtonTapped = PublishRelay<Void>()
    let shareButtonTapped = PublishRelay<Void>()

    init(_ place: BehaviorSubject<PlaceModel>) {
        
        placeName = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        address = place
            .compactMap { $0.address }
            .asDriver(onErrorJustReturn: "")

        sector = place
            .compactMap { $0.sector }
            .asDriver(onErrorJustReturn: "")

        share = shareButtonTapped
            .withLatestFrom(place)
            .compactMap { $0.link }
            .asSignal(onErrorJustReturn: "")

        // MARK: bookmark

        let bookmarked = BehaviorSubject<Bool>(value: false)
        let addBookmark = PublishSubject<Void>()
        let deleteBookmark = PublishSubject<Void>()
        
        place
            .compactMap { $0.bookmarkYn }
            .bind(to: bookmarked)
            .disposed(by: bag)
        
        bookmarkYn = bookmarked
            .asDriver(onErrorJustReturn: false)

        bookmarkButtonTapped
            .withLatestFrom(bookmarked)
            .subscribe(onNext: {
                switch $0 {
                case true:
                    deleteBookmark.onNext(())
                case false:
                    addBookmark.onNext(())
                }
            })
            .disposed(by: bag)

        addBookmark
            .filter { DeviceManager.shared.networkStatus }
            .withLatestFrom(place)
            .do(onNext: {
                $0.bookmarkYn = true
                $0.bookmarkCount = ($0.bookmarkCount ?? 0) + 1
                place.onNext($0)
            })
            .withLatestFrom(place)
            .compactMap { $0.id }
            .flatMap { PlaceAPI.shared.addBookmark($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    Singleton.shared.myPlaceRefresh.onNext(())
                    Singleton.shared.toastAlert.onNext("저장 장소에 등록되었습니다")
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
    
        deleteBookmark
            .filter { DeviceManager.shared.networkStatus }
            .withLatestFrom(place)
            .do(onNext: {
                $0.bookmarkYn = false
                $0.bookmarkCount = ($0.bookmarkCount ?? 0) - 1
                place.onNext($0)
            })
            .withLatestFrom(place)
            .compactMap { $0.id }
            .flatMap { PlaceAPI.shared.deleteBookmark($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    Singleton.shared.myPlaceRefresh.onNext(())
                    Singleton.shared.toastAlert.onNext("저장 장소에서 제거되었습니다")
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

        pushPlaceDetailVC = insideButtonTapped
            .map { PlaceDetailViewModel(place) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
