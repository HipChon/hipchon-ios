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
    var likeCount: Int?
    let commentCount: Int?
    var likeYn: Bool?
    
    // 아직 안씀
    let userPostCount: Int?

    enum Codingkeys: String, CodingKey {
        case postDt, user, place, likeYn
        
        case id = "postId"
        case imageURLs = "imageList"
        case likeCount = "likeCnt"
        case commentCount = "commentCnt"
        case content = "detail"
        
        case userPostCount = "userPostCnt"
    }

    var formattedPostDate: String? {
        guard let postDt = postDt else {
            return nil
        }
        let date = postDt.strToDate()
        return date.dateToStr(dateFormat: "yyyy.MM.dd")
    }
}
