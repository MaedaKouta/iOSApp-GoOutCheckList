import RealmSwift
import Foundation

public class Category: Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var assetsImageName: String = ""
    var checkItems = List<CheckItem>()

    // idをプライマリキーに設定
    public override static func primaryKey() -> String? {
        return "id"
    }
}
