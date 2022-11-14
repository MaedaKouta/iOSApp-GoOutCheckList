//
//  FindRealmData.swift
//  CheckItemsMiddleWidgetExtension
//
//  Created by 前田航汰 on 2022/11/14.
//

import Foundation
import RealmSwift

struct FindRealmData {
    let categoryListObject = RealmManager().realm.objects(CategoryList.self)
    let userdefault = UserdefaultsManager()

    func getWidgetCategory() -> Category? {
        let index = findWidgetCategoryIdIndex()
        let category = categoryListObject.elements.first?.list[index]

        return category
    }

    private func findWidgetCategoryIdIndex() -> Int {
        guard let categoryObjects = categoryListObject.first?.list else {
            return 0
        }
        if categoryObjects.count == 0 {
            return 0
        }

        var widgetCategoryIndex = 0
        for i in 0..<categoryObjects.elements.count {
            if categoryObjects.elements[i].id == userdefault.getWidgetCategoryId() {
                widgetCategoryIndex = i
            }
        }
        return widgetCategoryIndex
    }

}
