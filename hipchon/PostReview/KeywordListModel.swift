//
//  KeywordListModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/16.
//

import Foundation
import UIKit

struct KeywordListModel {
    let title: String?
    let keywords: [KeywordModel]?
    let selectedColor: UIColor?

    static var model: [KeywordListModel] {
        [
            KeywordListModel(title: "시설",
                             keywords: [
                                 KeywordModel(id: 1, content: "화장실이 청결해요"),
                                 KeywordModel(id: 2, content: "주차하기 용이해요"),
                                 KeywordModel(id: 3, content: "매장이 넓어요"),
                                 KeywordModel(id: 4, content: "좌석이 편해요"),
                                 KeywordModel(id: 5, content: "인터넷 접속이 원활해요"),
                             ],
                             selectedColor: .secondary_yellow),
            KeywordListModel(title: "분위기",
                             keywords: [
                                 KeywordModel(id: 6, content: "인테리어가 멋있어요"),
                                 KeywordModel(id: 7, content: "주변 경관이 좋아요"),
                                 KeywordModel(id: 8, content: "사진 찍기 좋아요"),
                                 KeywordModel(id: 9, content: "단체 모임 하기 좋아요"),
                                 KeywordModel(id: 10, content: "작업하기 좋아요"),
                             ],
                             selectedColor: .primary_green),
            KeywordListModel(title: "만족도",
                             keywords: [
                                 KeywordModel(id: 11, content: "직원분들이 친절해요"),
                                 KeywordModel(id: 12, content: "음식이 맛있어요"),
                                 KeywordModel(id: 13, content: "체험활동이 재밌어요"),
                                 KeywordModel(id: 14, content: "아이들이 좋아해요"),
                                 KeywordModel(id: 15, content: "친구가 좋아해요"),
                             ],
                             selectedColor: .secondary_blue),
        ]
    }
}
