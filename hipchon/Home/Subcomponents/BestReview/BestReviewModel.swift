//
//  BestReviewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import Foundation

class BestReviewModel: Codable {
    let id: Int?
    let title: String?
    let reviewId: Int?
    let hashtag: HashtagModel?
    
    var review: ReviewModel? {
        return ReviewModel(id: reviewId)
    }

    enum CodingKeys: String, CodingKey {
        case id, title, hashtag
        case reviewId = "postId"
    }
}
