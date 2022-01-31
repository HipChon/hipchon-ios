//
//  HomeViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import RxCocoa
import RxSwift

struct CategoryModel {
    let name: String?
}

class HomeViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let mainFilterViewModel = MainFilterViewModel()

    // MARK: viewModel -> view

    let cateogorys: Driver<[CategoryModel]>

    // MARK: view -> viewModel

    init() {
        let tmps = [
            CategoryModel(name: "오션뷰"),
            CategoryModel(name: "바다근처"),
            CategoryModel(name: "시골살기"),
            CategoryModel(name: "마당"),
            CategoryModel(name: "재택근무"),
            CategoryModel(name: "숲세권"),
            CategoryModel(name: "돌담"),
            CategoryModel(name: "뚜벅이"),
            CategoryModel(name: "반려동물"),
            CategoryModel(name: "프리미엄"),
        ]

        let datas = BehaviorSubject<[CategoryModel]>(value: tmps)

        cateogorys = datas
            .asDriver(onErrorJustReturn: [])
    }
}
