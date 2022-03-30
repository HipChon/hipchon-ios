//
//  KeywordModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/16.
//

import UIKit

struct KeywordModel: Codable {
    let id: Int?
    let content: String?
    let count: Int?

    enum CodingKeys: String, CodingKey {
        case id = "keywordId"
        case content = "keyword"
        case count = "postCnt"
    }

    init(id: Int?, content: String?) {
        self.id = id
        self.content = content
        count = nil
    }

    var iconImage: UIImage? {
        guard let content = content else {
            return nil
        }
        return UIImage(named: content)
    }

    var selectedColor: UIColor {
        guard let content = content else {
            return UIColor.secondary_yellow
        }

        if content == "화장실이 청결해요" ||
            content == "주차하기 용이해요" ||
            content == "매장이 넓어요" ||
            content == "좌석이 편해요" ||
            content == "인터넷 접속이 원활해요"
        {
            return .secondary_yellow
        } else if content == "인테리어가 멋있어요" ||
            content == "주변 경관이 좋아요" ||
            content == "사진 찍기 좋아요" ||
            content == "단체 모임 하기 좋아요" ||
            content == "작업하기 좋아요"
        {
            return .primary_green
        } else if content == "직원분들이 친절해요" ||
            content == "음식이 맛있어요" ||
            content == "체험활동이 재밌어요" ||
            content == "아이들이 좋아해요" ||
            content == "친구가 좋아해요"
        {
            return .secondary_blue
        }
        return UIColor.secondary_yellow
    }
}
