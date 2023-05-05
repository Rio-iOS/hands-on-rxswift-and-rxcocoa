//
//  SectionModel.swift
//  FoodApp
//
//  Created by 藤門莉生 on 2023/05/02.
//

import Foundation
import RxDataSources

struct SectionModel {
    var header: String
    var items: [Food]
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [Food]) {
        self = original
        self.items = items
    }
}
