//
//  ReviewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import Foundation

class ReviewModel: Codable {
    let id: Int?
    let content: String?
    let postDt: String?
    let imageURLs: [String]?
    let user: UserModel?
    let place: PlaceModel?
    let likeCount: Int?
    let commentCount: Int?
    let likeYn: Bool?

    enum Codingkeys: String, CodingKey {
        case id, content, postDt, imageURLs, user, place, compliments, likeCount, commentCount, likeYn
    }
    
    var formattedPostDate: String? {
        guard let postDt = postDt else {
            return nil
        }
        let date = postDt.strToDate()
        return date.dateToStr(dateFormat: "yyyy.MM.dd")
    }
}
