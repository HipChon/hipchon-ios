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
        self.id = region.id
        self.name = region.name
    }
    
    init(category: CategoryModel) {
        self.id = category.id
        self.name = category.name
    }
    
    var region: RegionModel {
        return RegionModel(id: id, name: name)
    }

    var category: CategoryModel {
        return CategoryModel(id: id, name: name)
    }
}
