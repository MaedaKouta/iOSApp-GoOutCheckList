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

public class CheckHistoryList: Object {

    var checkHistoryList = List<CheckHistory>()

}


