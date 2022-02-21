//
//  FilterViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/31.
//

import RxRelay
import RxSwift

class FilterViewModel {
    private let bag = DisposeBag()

    let findButtonTapped = PublishRelay<Void>()

    init() {}
}
