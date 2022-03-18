//
//  FilterModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/26.
//

import Foundation

class SearchFilterModel: Codable {
    let personnel: Int?
    let pet: Bool?
    let region: String?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case personnel, pet, region, category
    }

    init(personnel: Int?, pet: Bool?, region: String?, category: String?) {
        self.personnel = personnel
        self.pet = pet
        self.region = region
        self.category = category
    }

    var filterTitle: String? {
        var titles: [String] = []
        if let personnel = personnel,
           personnel != 0
        {
            titles.append("\(personnel)인")
        }
        if let pet = pet,
           pet == true
        {
            titles.append("반려동물")
        }
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
