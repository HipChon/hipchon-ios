//
//  MyPlaceCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift

class MyPlaceCellViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let imageURL: Driver<URL>
    let name: Driver<String>
    let category: Driver<String>
    let address: Driver<String>

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)

        imageURL = place
            .compactMap { $0.imageURLs?.first }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        name = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        category = place
            .compactMap { $0.category }
            .asDriver(onErrorJustReturn: "")

        address = place
            .compactMap { $0.address }
            .asDriver(onErrorJustReturn: "")
    }
}
