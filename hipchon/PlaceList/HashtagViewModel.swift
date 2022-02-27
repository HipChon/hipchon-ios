//
//  HashtagViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/26.
//

import RxCocoa
import RxRelay
import RxSwift

class HashtagViewModel {
    // MARK: viewModel -> view

    let setHashtag: Driver<String>

    let hashtag = BehaviorSubject<String>(value: "")

    init() {
        setHashtag = hashtag
            .asDriver(onErrorJustReturn: "")
    }
}
