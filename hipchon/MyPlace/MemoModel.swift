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
    
    var backgroundColor: UIColor {
        switch color ?? "" {
        case "green":
            return .primary_green
        case "yello":
            return .secondary_yellow
        case "blue":
            return .secondary_blue
        case "red":
            return .secondary_red
        case "purple":
            return .secondary_red
        default:
            return .gray01
        }
    }
}
