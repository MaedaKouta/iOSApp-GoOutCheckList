//
//  CheckItem.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/08.
//

import RealmSwift
import Foundation

public class CheckItem: Object {

    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var isDone: Bool = false

    // idをプライマリキーに設定
    public override static func primaryKey() -> String? {
        return "id"
    }

}
