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

    let firstHashtagVM = HashtagViewModel()
    let secondHashtagVM = HashtagViewModel()
    let thirdHashtagVM = HashtagViewModel()

    // MARK: viewModel -> voew

    let placeImageURLs: Driver<[URL]>
    let title: Driver<String>
    let distanceKm: Driver<String>
    let priceDes: Driver<String>
    let bookmarkCount: Driver<Int>
    let reviewCount: Driver<Int>

    let imageCount: Driver<Int>

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)

        placeImageURLs = place
            .compactMap { $0.imageURLs }
            .map { $0.compactMap { URL(string: $0) } }
            .asDriver(onErrorJustReturn: [])

        title = place
            .compactMap { $0.placeTitle }
            .asDriver(onErrorJustReturn: "")

        priceDes = place
            .compactMap { $0.priceDes }
            .asDriver(onErrorJustReturn: "")

        distanceKm = place
            .compactMap { $0.distanceKm }
            .asDriver(onErrorJustReturn: "")

        bookmarkCount = place
            .compactMap { $0.bookmarkCount }
            .asDriver(onErrorJustReturn: 0)

        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)

        imageCount = place
            .compactMap { $0.imageURLs?.count }
            .asDriver(onErrorJustReturn: 0)

        place
            .compactMap { $0.hashtags }
            .filter { $0.count >= 1 }
            .compactMap { $0[0] }
            .bind(to: firstHashtagVM.hashtag)
            .disposed(by: bag)

        place
            .compactMap { $0.hashtags }
            .filter { $0.count >= 2 }
            .compactMap { $0[1] }
            .bind(to: secondHashtagVM.hashtag)
            .disposed(by: bag)

        place
            .compactMap { $0.hashtags }
            .filter { $0.count >= 3 }
            .compactMap { $0[2] }
            .bind(to: thirdHashtagVM.hashtag)
            .disposed(by: bag)
    }
}
