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

    public static var tmpModels: [FilterCellModel] {
        return [
            FilterCellModel(name: "나만의"),
            FilterCellModel(name: "반려동물"),
        ]
    }

    public static var regionModels: [FilterCellModel] {
        return [
            FilterCellModel(name: "제주"),
            FilterCellModel(name: "속초 / 고성"),
            FilterCellModel(name: "강릉"),
            FilterCellModel(name: "양양 / 동해"),
            FilterCellModel(name: "남해 / 통영"),
            FilterCellModel(name: "거제 / 여수"),
            FilterCellModel(name: "전주 / 군산"),
            FilterCellModel(name: "창원 / 부산"),
        ]
    }

    public static var categoryModels: [FilterCellModel] {
        return [
            FilterCellModel(name: "불멍"),
            FilterCellModel(name: "논멍"),
            FilterCellModel(name: "물멍"),
            FilterCellModel(name: "밭멍"),
            FilterCellModel(name: "촌캉스"),
            FilterCellModel(name: "체험"),
            FilterCellModel(name: "가게"),
            FilterCellModel(name: "기타"),
        ]
    }
}
