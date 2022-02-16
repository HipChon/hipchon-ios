//
//  PickViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxRelay
import RxSwift

class PickViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let picks: Driver<[BannerModel]>

    // MARK: view -> viewModel

    init() {
        picks = Driver.just(BannerModel.tmpModels)
    }
}
