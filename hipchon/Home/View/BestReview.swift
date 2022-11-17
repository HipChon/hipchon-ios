//
//  BestReviewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import Foundation

class BestReview: Codable {
    let id: Int?
    let title: String?
    let reviewId: Int?
    let hashtag: Hashtag?

    var review: Review? {
        return Review(id: reviewId)
    }

    enum CodingKeys: String, CodingKey {
        case id, title, hashtag
        case reviewId = "postId"
    }
}
