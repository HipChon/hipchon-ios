//
//  PlaceMapViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/03.
//

import RxCocoa
import RxSwift

class PlaceMapViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let setAddress: Driver<String>
    let setMapCenter: Driver<MTMapPoint>

    // MARK: view -> viewModel

    let address = BehaviorSubject<String>(value: "")
    let mtMapPoint = BehaviorSubject<MTMapPoint>(value: MTMapPoint())
    let copyButtonTapped = PublishRelay<Void>()

    init() {
        setAddress = address
            .asDriver(onErrorJustReturn: "")

        setMapCenter = mtMapPoint
            .asDriver(onErrorDriveWith: .empty())
    }
}
