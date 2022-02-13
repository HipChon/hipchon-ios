//
//  CategoryModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import Foundation

struct CategoryModel {
    let name: String?

    static var tmpModels: [CategoryModel] {
        return [
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
    }
}
