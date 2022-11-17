//
//  CategoryModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/26.
//

import UIKit

class Category: Codable {
    let id: Int?
    let name: String?

    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case id, name
    }

    static var model: [Category] {
        return [
            Category(id: 1, name: "카페"),
            Category(id: 2, name: "미식"),
            Category(id: 3, name: "활동"),
            Category(id: 4, name: "자연"),
        ]
    }
}
