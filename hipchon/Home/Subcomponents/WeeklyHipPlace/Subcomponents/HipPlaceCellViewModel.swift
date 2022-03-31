//
//  HipPlaceCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift

class HipPlaceCellViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let keywordVM: Driver<KeywordViewModel>

    // MARK: viewModel -> view

    let url: Driver<URL>
    let name: Driver<String>
    let bookmarkYn: Driver<Bool>
    let region: Driver<String>
    let bookmarkCount: Driver<Int>
    let reviewCount: Driver<Int>

    // MARK: view -> viewModel

    let bookmarkButtonTapped = PublishRelay<Void>()

    init(_ place:  BehaviorSubject<PlaceModel>) {

        keywordVM = place
            .compactMap { $0.topKeyword }
            .map { KeywordViewModel($0) }
            .asDriver(onErrorDriveWith: .empty())

        url = place
            .compactMap { $0.topImageUrl }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        name = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        region = place
            .compactMap { $0.region }
            .asDriver(onErrorJustReturn: "")

        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)

        // MARK: bookmark

        let bookmarked = BehaviorSubject<Bool>(value: false)
        let bookmarkCounted = BehaviorSubject<Int>(value: 0)
        let addBookmark = PublishSubject<Void>()
        let deleteBookmark = PublishSubject<Void>()

        bookmarkYn = bookmarked
            .asDriver(onErrorJustReturn: false)
        
        bookmarkCount = bookmarkCounted
            .asDriver(onErrorJustReturn: 0)
        
        place
            .compactMap { $0.bookmarkYn }
            .bind(to: bookmarked)
            .disposed(by: bag)
        
        place
            .compactMap { $0.bookmarkCount }
            .bind(to: bookmarkCounted)
            .disposed(by: bag)

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
            .withLatestFrom(place)
            .do(onNext: {
                $0.bookmarkYn = true
                $0.bookmarkCount = ($0.bookmarkCount ?? 0) + 1
                place.onNext($0)
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
            .withLatestFrom(place)
            .do(onNext: {
                $0.bookmarkYn = false
                $0.bookmarkCount = ($0.bookmarkCount ?? 0) - 1
                place.onNext($0)
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
    }
}
