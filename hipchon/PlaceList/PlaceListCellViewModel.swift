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

    // MARK: viewModel -> voew

    let name: Driver<String>
    let address: Driver<String>
    let category: Driver<String>
    let placeImageURLs: Driver<[URL]>

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)

        name = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        address = place
            .compactMap { $0.address }
            .asDriver(onErrorJustReturn: "")

        category = place
            .compactMap { $0.category }
            .asDriver(onErrorJustReturn: "")

        placeImageURLs = place
            .compactMap { $0.imageURLs }
            .map { $0.compactMap { URL(string: $0) } }
            .asDriver(onErrorJustReturn: [])
    }
}
