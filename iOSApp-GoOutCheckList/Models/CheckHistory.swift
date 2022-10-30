//
//  CheckHistory.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/26.
//

import Foundation
import RealmSwift

public class CheckHistory: Object {

    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var date: Date = Date()
    @objc dynamic var categoryName: String = ""
    @objc dynamic var assetsImageName: String = ""

    // idをプライマリキーに設定
    public override static func primaryKey() -> String? {
        return "id"
    }

}
