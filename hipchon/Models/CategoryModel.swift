//
//  CategoryModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/26.
//

import UIKit

class CategoryModel: Codable {
    let id: Int?
    let name: String?
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }

    static var model: [CategoryModel] {
        return [
            CategoryModel(id: 1, name: "카페"),
            CategoryModel(id: 2, name: "미식"),
            CategoryModel(id: 3, name: "활동"),
            CategoryModel(id: 4, name: "자연"),
        ]
    }
}
