//
//  FilterModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/23.
//

import Foundation

class FilterCellModel {
    let id: Int?
    let name: String?

    init() {
        id = nil
        name = nil
    }

    init(region: Region) {
        id = region.id
        name = region.name
    }

    init(category: Category) {
        id = category.id
        name = category.name
    }

    var region: Region {
        return Region(id: id, name: name)
    }

    var category: Category {
        return Category(id: id, name: name)
    }
}
