//
//  HashtagCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxCocoa
import RxRelay
import RxSwift

class HashtagCellViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let title: Driver<String>
    let image: Driver<UIImage>

    // MARK: view -> viewModel

    let hashtag = PublishRelay<Hashtag>()

    init() {
        title = hashtag
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        image = hashtag
            .compactMap { $0.image }
            .asDriver(onErrorJustReturn: UIImage())
    }
}
