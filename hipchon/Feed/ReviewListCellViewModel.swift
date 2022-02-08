//
//  ReviewListCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa

class ReviewListCellViewModel {
    let title: Driver<String>
    let content: Driver<String>
    let place: Driver<String>

    init(_ data: ReviewModel) {
        title = Driver.just(data.title ?? "")
        content = Driver.just(data.content ?? "")
        place = Driver.just(data.place ?? "")
    }
}
