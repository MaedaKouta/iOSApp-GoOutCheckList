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
    @objc dynamic var categoryID: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var isWatched: Bool = false
    // 上書きされた場合に、上書き前のデータを保存しておく必要がある。
    var checkItemList: List<CheckItem> = List<CheckItem>()

    // idをプライマリキーに設定
    public override static func primaryKey() -> String? {
        return "id"
    }

}
