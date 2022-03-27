//
//  KeywordViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/22.
//

import RxCocoa
import RxSwift

class KeywordViewModel {
    let backgroundColor: Driver<UIColor>
    let content: Driver<String>
    let iconImage: Driver<UIImage>

    init(_ data: KeywordModel) {
        let keyword = BehaviorSubject<KeywordModel>(value: data)

        backgroundColor = keyword
            .compactMap { $0.selectedColor }
            .asDriver(onErrorJustReturn: .white)

        content = keyword
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")

        iconImage = keyword
            .compactMap { $0.iconImage }
            .asDriver(onErrorJustReturn: UIImage())
    }
}
