//
//  ComplimentModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/09.
//

import Foundation
import UIKit

struct ComplimentModel: Codable {
    let content: String?
    let count: Int?
    
    enum CodingKeys: String, CodingKey {
        case content, count
    }
    
    var logoImage: UIImage? {
        guard let content = content else {
            return nil
        }

        switch content {
        default:
            return UIImage(named: "search")
        }
    }
    
    var backgroundColor: UIColor? {
        guard let content = content else {
            return nil
        }
        
        switch content {
        default:
            return UIColor.secondary_yellow
        }
    }
}
