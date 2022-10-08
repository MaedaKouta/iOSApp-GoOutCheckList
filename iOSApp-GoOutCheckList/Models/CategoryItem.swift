//
//  CategoryItem.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/08.
//

import RealmSwift
import Foundation

public class CategoryItem: Object {

    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var imageData: Data = (UIImage(named: "unknownImage")?.pngData())!
    var checkItems = List<CheckItem>()

    // idをプライマリキーに設定
    public override static func primaryKey() -> String? {
        return "id"
    }

}
