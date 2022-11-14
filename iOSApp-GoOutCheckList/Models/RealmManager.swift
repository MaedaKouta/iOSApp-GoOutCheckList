//
//  RealmManager.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/11/13.
//

import Foundation
import RealmSwift

// Realmの保存先をWidgetと同じ保存先にする
public class RealmManager {
    var realm:Realm {
        var config = Realm.Configuration()
        config.fileURL = fileUrl
        return try! Realm(configuration: config)
    }

    var fileUrl: URL {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.realmWithWidget")!
        return url.appendingPathComponent("db.realm")
    }
}
