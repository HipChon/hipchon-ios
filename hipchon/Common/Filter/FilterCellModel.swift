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

    init(region: RegionModel) {
        id = region.id
        name = region.name
    }

    init(category: CategoryModel) {
        id = category.id
        name = category.name
    }

    var region: RegionModel {
        return RegionModel(id: id, name: name)
    }

    var category: CategoryModel {
        return CategoryModel(id: id, name: name)
    }
}
