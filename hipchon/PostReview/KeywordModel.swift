//
//  KeywordModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/16.
//

import UIKit

struct KeywordModel: Codable {
    let content: String?
    let count: Int?
    
    enum CodingKeys: String, CodingKey {
        case content, count
    }
    
    init(content: String?) {
        self.content = content
        self.count = nil
    }
    
    var iconImage: UIImage? {
        switch self.content {
        default:
            return UIImage(named: "setting")
        }
    }
    
    var selectedColor: UIColor {
        switch self.content {
        default:
            return UIColor.secondary_yellow
        }
    }
}
