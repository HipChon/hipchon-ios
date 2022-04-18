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
    let imageURLs: [String?]?
    let topImageUrl: String?
    let user: UserModel?
    let place: PlaceModel?
    var likeCount: Int?
    let commentCount: Int?
    var likeYn: Bool?
    let placeName: String?

    // 아직 안씀
//    let userPostCount: Int?

    init(id: Int?) {
        self.id = id
        content = nil
        postDt = nil
        imageURLs = nil
        user = nil
        place = nil
        likeCount = nil
        commentCount = nil
        likeYn = nil
        topImageUrl = nil
        placeName = nil
    }

    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case imageURLs = "imageList"
        case likeCount = "likeCnt"
        case commentCount = "commentCnt"
        case content = "detail"
        case postDt = "time"
        case likeYn = "isMypost"
        case topImageUrl = "image"
        case user, place
        case placeName = "name"
//        case userPostCount = "userPostCnt"
    }

    var formattedPostDate: String? {
        guard let postDt = postDt else {
            return nil
        }
        let date = postDt.strToDate()
        return date.dateToStr(dateFormat: "yyyy.MM.dd")
    }
    
    var isBlock: Bool {
        guard let userBlockArr = UserDefaults.standard.value(forKey: "userBlock") as? [Int],
              let reviewBlockArr = UserDefaults.standard.value(forKey: "reviewBlock") as? [Int],
              let userId = user?.id,
              let reviewId = id else { return false }
        return userBlockArr.contains(userId) || reviewBlockArr.contains(reviewId)
    }
}
