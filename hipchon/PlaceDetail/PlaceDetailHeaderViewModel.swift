//
//  PlaceDetailHeaderViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxCocoa
import RxSwift

class PlaceDetailHeaderViewModel {
    private let bag = DisposeBag()


//    let pushReviewDetailVC: Signal<ReviewDetailViewModel>

    // MARK: view -> viewModel

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)

       
    }
}
