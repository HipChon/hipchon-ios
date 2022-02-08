//
//  ReviewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import Foundation

class ReviewModel: Codable {
    let title: String?
    let content: String?
    let place: String?
    
    enum Codingkeys: String, CodingKey {
        case title
        case content
        case place
    }
    
    init(title: String, content: String, place: String) {
        self.title = title
        self.content = content
        self.place = place
    }
    
}
