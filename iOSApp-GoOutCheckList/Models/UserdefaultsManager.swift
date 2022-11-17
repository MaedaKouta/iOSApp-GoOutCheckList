//
//  UserdefaultsManager.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/11/14.
//

import Foundation

// Realmの保存先をWidgetと同じ保存先にする
public class UserdefaultsManager {
    let userdefault = UserDefaults(suiteName: "group.org.tetoblog.iOSApp-GoOutCheckList.userdefault")

    // isDisplayHistoryNumber
    func setIsDisplayHistoryNumber(isDisplay: Bool) {
        userdefault!.set(isDisplay, forKey: "isDisplayHistoryNumber")
    }

    func getIsDisplayHistoryNumber() -> Bool {
        return userdefault!.bool(forKey: "isDisplayHistoryNumber")
    }

    // widgetCategoryId
    func setWidgetCategoryId(id: String) {
        userdefault!.set(id, forKey: "widgetCategoryId")
    }

    func getWidgetCategoryId() -> String {
        return userdefault!.string(forKey: "widgetCategoryId") ?? ""
    }

    // isFromWidget
    func setIsDisplayFromWidget(isTrue: Bool) {
        userdefault!.set(isTrue, forKey: "isDisplayFromWidget")
    }

    func getIsDisplayFromWidget() -> Bool {
        return userdefault!.bool(forKey: "isDisplayFromWidget")
    }

    // indexFromWidget
    func setIndexFromWidget(index: Int) {
        userdefault!.set(index, forKey: "indexFromWidget")
    }

    func getIsFromWidget() -> Int {
        return userdefault!.integer(forKey: "indexFromWidget")
    }

}
