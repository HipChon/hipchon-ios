//
//  PlaceDetailHeaderViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxSwift
import RxCocoa

class PlaceDetailHeaderViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels
    let placeDesVM = PlaceDesViewModel()
    let placeMapVM = PlaceMapViewModel()
    let menuListVM: Signal<MenuListViewModel>
    let reviewComplimentListVM: Signal<ReviewComplimentListViewModel>

    // MARK: viewModel -> view

    let menuListViewHidden: Driver<Bool>
    let urls: Driver<[URL]>
    let openURL: Signal<URL>
    let share: Signal<Void>
//    let pushReviewDetailVC: Signal<ReviewDetailViewModel>

    // MARK: view -> viewModel

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)
        
        menuListViewHidden = place
            .compactMap { $0.menus }
            .map { $0.count == 0 }
            .asDriver(onErrorJustReturn: true)

        urls = place
            .compactMap { $0.imageURLs?.compactMap { URL(string: $0) } }
            .asDriver(onErrorJustReturn: [])
        
        place
            .compactMap { $0.name }
            .bind(to: placeDesVM.placeName)
            .disposed(by: bag)
        
        place
            .compactMap { $0.reviewCount }
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
            .flatMap { NetworkManager.shared.getPlaceDetail($0) }
            .asObservable()
            .subscribe(onNext: {
                place.onNext($0)
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
        
        menuListVM = place
            .compactMap { $0.menus }
            .map { MenuListViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
        
        reviewComplimentListVM = place
            .compactMap { $0.compliments }
            .map { ReviewComplimentListViewModel($0) }
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
        
        share = placeDesVM.sharedButtonTapped
            .asSignal()
        
        placeMapVM
            .copyButtonTapped
            .withLatestFrom(place)
            .compactMap { $0.address }
            .subscribe(onNext: {
                UIPasteboard.general.string = $0
            })
            .disposed(by: bag)
        
    }
}
