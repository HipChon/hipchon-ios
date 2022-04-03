//
//  MemoModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/19.
//

import Foundation
import UIKit

class MemoModel: Codable {
    let content: String?
    let color: String?

    enum CodingKeys: String, CodingKey {
        case content, color
    }

    init() {
        content = nil
        color = nil
    }
    
    init(content: String?, color: String?) {
        self.content = content
        self.color = color
    }

    var backgroundColor: UIColor {
        switch color ?? "" {
        case "primary_green":
            return .primary_green
        case "secondary_yellow":
            return .secondary_yellow
        case "secondary_blue":
            return .secondary_blue
        case "secondary_purple":
            return .secondary_purple
        default:
            return .gray01
        }
    }
}
