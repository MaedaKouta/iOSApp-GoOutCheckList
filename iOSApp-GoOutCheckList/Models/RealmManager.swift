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
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.org.tetoblog.iOSApp-GoOutCheckList.realm")!
        return url.appendingPathComponent("db.realm")
    }
}
