//
//  FilterModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/26.
//

import Foundation

class SearchFilterModel {
    let region: RegionModel?
    let category: CategoryModel?
    let hashtag: HashtagModel?

    init(region: RegionModel?, category: CategoryModel?) {
        self.region = region
        self.category = category
        hashtag = nil
    }

    init(hashtag: HashtagModel?) {
        self.hashtag = hashtag
        region = nil
        category = nil
    }

    var filterTitle: String? {
        var titles: [String] = []
        if let region = region?.name,
           region != ""
        {
            titles.append("\(region)")
        }
        if let category = category?.name,
           category != ""
        {
            titles.append("\(category)")
        }
        if let hashtag = hashtag?.name,
           hashtag != ""
        {
            titles.append("\(hashtag)")
        }
        return titles.joined(separator: " | ")
    }
}
