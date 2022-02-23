//
//  FilterModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/23.
//

import Foundation

class FilterModel {
    let name: String?

    init(name: String) {
        self.name = name
    }

    public static var tmpModels: [FilterModel] {
        return [
            FilterModel(name: "나만의"),
            FilterModel(name: "반려동물"),
        ]
    }

    public static var regionModels: [FilterModel] {
        return [
            FilterModel(name: "제주"),
            FilterModel(name: "속초 / 고성"),
            FilterModel(name: "강릉"),
            FilterModel(name: "양양 / 동해"),
            FilterModel(name: "남해 / 통영"),
            FilterModel(name: "거제 / 여수"),
            FilterModel(name: "전주 / 군산"),
            FilterModel(name: "창원 / 부산"),
        ]
    }

    public static var categoryModels: [FilterModel] {
        return [
            FilterModel(name: "불멍"),
            FilterModel(name: "논멍"),
            FilterModel(name: "물멍"),
            FilterModel(name: "밭멍"),
            FilterModel(name: "촌캉스"),
            FilterModel(name: "체험"),
            FilterModel(name: "가게"),
            FilterModel(name: "기타"),
        ]
    }
}
