//
//  FilterModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/26.
//

import Foundation

class SearchFilterModel: Codable {
    let region: String?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case region, category
    }

    init(region: String?, category: String?) {
        self.region = region
        self.category = category
    }

    var filterTitle: String? {
        var titles: [String] = []
        if let region = region,
           region != ""
        {
            titles.append("\(region)")
        }
        if let category = category,
           category != ""
        {
            titles.append("\(category)")
        }
        return titles.joined(separator: " | ")
    }
}
