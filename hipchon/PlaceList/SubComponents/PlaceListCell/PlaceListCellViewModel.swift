//
//  PlaceListCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxCocoa
import RxSwift

class PlaceListCellViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let pageCountVM = PageCountViewModel()
    let keywordVM: Driver<KeywordViewModel>

    // MARK: viewModel -> view

    let placeImageURLs: Driver<[URL]>
    let name: Driver<String>
    let bookmarkYn: Driver<Bool>
    let region: Driver<String>
    let priceDes: Driver<String>
    let bookmarkCount: Driver<Int>
    let reviewCount: Driver<Int>

    // MARK: view -> viewModel

    let bookmarkButtonTapped = PublishRelay<Void>()
    let currentIdx = BehaviorRelay<Int>(value: 1)

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)

        keywordVM = place
            .compactMap { $0.keywords?.first }
            .map { KeywordViewModel($0) }
            .asDriver(onErrorDriveWith: .empty())

        placeImageURLs = place
            .compactMap { $0.imageURLs }
            .map { $0.compactMap { URL(string: $0) } }
            .asDriver(onErrorJustReturn: [])

        name = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        priceDes = place
            .compactMap { $0.priceDes }
            .asDriver(onErrorJustReturn: "")

        region = place
            .compactMap { $0.region }
            .asDriver(onErrorJustReturn: "")

        bookmarkCount = place
            .compactMap { $0.bookmarkCount }
            .asDriver(onErrorJustReturn: 0)

        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)

        place
            .compactMap { $0.imageURLs?.count }
            .bind(to: pageCountVM.entireIdx)
            .disposed(by: bag)

        currentIdx
            .map { $0 + 1 }
            .bind(to: pageCountVM.currentIdx)
            .disposed(by: bag)

        // MARK: bookmark

        let bookmarked = BehaviorSubject<Bool>(value: data.bookmarkYn ?? false)

        bookmarkYn = bookmarked
            .asDriver(onErrorJustReturn: false)

        let addBookmark = PublishSubject<Void>()
        let deleteBookmark = PublishSubject<Void>()

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
            .do(onNext: { bookmarked.onNext(true) })
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
            .do(onNext: { bookmarked.onNext(false) })
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
