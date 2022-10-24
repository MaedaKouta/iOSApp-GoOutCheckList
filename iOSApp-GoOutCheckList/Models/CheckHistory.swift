//
//  CheckHistory.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/24.
//
/*
 チェックした履歴を保存しておく
 外出時に、あれチェックしたかな？って振り返るために作成
 過去30件までを保存しておく
 */

import Foundation
import RealmSwift

public class CheckHistory: Object {
    @objc dynamic var date: Date = Date()
    @objc dynamic var categoryName: String = ""

    open var primaryKey: String {
        return "date"
    }
}
