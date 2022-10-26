//
//  CheckHistory.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/26.
//

import Foundation
import RealmSwift

class CheckHistory: Object {

    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var date: Date = Date()
    @objc dynamic var categoryName: String = ""

    // idをプライマリキーに設定
    public override static func primaryKey() -> String? {
        return "id"
    }

}
