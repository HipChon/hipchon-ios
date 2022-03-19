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

    enum CodingKeys: String, CodingKey {
        case id, user, content, dateTime
    }
    
    var relatedDT: String? {
        guard let dateTime = dateTime else {
            return nil
        }
        return dateTime.strToDate().relativeTime
    }
}
