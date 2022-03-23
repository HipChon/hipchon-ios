//
//  FilterModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/26.
//

import Foundation

class SearchFilterModel {
    let region: String?
    let category: String?
    let hashtag: String?

    init(region: String?, category: String?) {
        self.region = region
        self.category = category
        hashtag = nil
    }

    init(hashtag: String?) {
        self.hashtag = hashtag
        region = nil
        category = nil
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
        if let hashtag = hashtag,
           hashtag != ""
        {
            titles.append("\(hashtag)")
        }
        return titles.joined(separator: " | ")
    }
}
