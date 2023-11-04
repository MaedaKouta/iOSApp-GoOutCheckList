import Foundation
import RealmSwift

/*
 チェックした履歴を保存しておく
 外出時に、あれチェックしたかな？って振り返るために作成
 過去30件までを保存しておく
 */
public class CheckHistoryList: Object {
    var checkHistoryList = List<CheckHistory>()
}

