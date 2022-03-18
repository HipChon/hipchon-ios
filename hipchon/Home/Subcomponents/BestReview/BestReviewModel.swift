//
//  BestReviewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import Foundation

class BestReviewModel: Codable {
    let id: Int?
    let imageURL: String?
    let review: ReviewModel?

    enum CodingKeys: String, CodingKey {
        case id, imageURL, review
    }
}
