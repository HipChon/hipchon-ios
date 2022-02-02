//
//  MainFilterViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/31.
//

import RxSwift
import RxRelay

class MainFilterViewModel {
    private let bag = DisposeBag()

    let findButtonTapped = PublishRelay<Void>()
    
    init() {}
}
