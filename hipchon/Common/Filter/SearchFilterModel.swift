//
//  FilterModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/26.
//

import Foundation

class SearchFilterModel {
    let region: Region?
    let category: Category?
    let hashtag: Hashtag?

    init(region: Region?, category: Category?) {
        self.region = region
        self.category = category
        hashtag = nil
    }

    init(hashtag: Hashtag?) {
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
        let title = titles.joined(separator: " | ")
        return title == "" ? "지역, 유형을 검색하세요" : title
    }
}
