//
//  FilterModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/23.
//

import Foundation

class FilterCellModel {
    let name: String?

    init(name: String) {
        self.name = name
    }

    public static var regionModels: [FilterCellModel] {
        return [
            FilterCellModel(name: "제주도"),
            FilterCellModel(name: "경기도"),
            FilterCellModel(name: "대구"),
            FilterCellModel(name: "부산"),
            FilterCellModel(name: "대전"),
            FilterCellModel(name: "강원도"),
            FilterCellModel(name: "경상북도"),
            FilterCellModel(name: "충청남도"),
            FilterCellModel(name: "인천"),
            FilterCellModel(name: "광주"),
            FilterCellModel(name: "충청북도"),
            FilterCellModel(name: "경상남도"),
            FilterCellModel(name: "전라북도"),
            FilterCellModel(name: "전라남도"),
            FilterCellModel(name: "울산"),
            FilterCellModel(name: "서울"),
        ]
    }

    public static var categoryModels: [FilterCellModel] {
        return [
            FilterCellModel(name: "카페"),
            FilterCellModel(name: "미식"),
            FilterCellModel(name: "활동"),
            FilterCellModel(name: "자연"),
        ]
    }
}
