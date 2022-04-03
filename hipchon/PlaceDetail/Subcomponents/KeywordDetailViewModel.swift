//
//  KeywordDetailViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/24.
//

import RxCocoa
import RxSwift

class KeywordDetailViewModel {
    let iconImage: Driver<UIImage>
    let content: Driver<String>
    let count: Driver<Int>
    let backgroundColor: Driver<UIColor>

    init(_ data: KeywordModel) {
        let keyword = BehaviorSubject<KeywordModel>(value: data)

        iconImage = keyword
            .compactMap { $0.iconImage }
            .asDriver(onErrorDriveWith: .empty())

        content = keyword
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")

        count = keyword
            .compactMap { $0.count }
            .asDriver(onErrorJustReturn: 0)

        backgroundColor = keyword
            .compactMap { $0.selectedColor }
            .asDriver(onErrorJustReturn: .white)
    }
}
