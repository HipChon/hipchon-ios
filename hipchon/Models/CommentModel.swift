//
//  CommentModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import Foundation

class CommentModel: Codable {
    let id: Int?
    let user: UserModel?
    let content: String?
    let dateTime: String?
    let review: ReviewModel?

    enum CodingKeys: String, CodingKey {
        case id = "commentId"
        case user
        case content = "detail"
        case dateTime = "time"
        case review = "post"
    }

    var relatedDT: String? {
        guard let dateTime = dateTime else {
            return nil
        }
        return dateTime.strToDate().relativeTime
    }

    var formattedDate: String? {
        guard let dateTime = dateTime else {
            return nil
        }
        let date = dateTime.strToDate()
        return date.dateToStr(dateFormat: "yyyy.MM.dd")
    }
}
