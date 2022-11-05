//
//  LostCheckDataSource.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/07.
//
import Foundation
import RxSwift
import RxCocoa
import UIKit
import RealmSwift

/*
 CheckItemTableViewControllerから呼ばれ、TableViewを管理するクラス
 RxSwiftでTableViewを監視するために必要
 RealmのデータでList<CheckItem>を使う必要があるため、ArrayではなくListが中心のコード
 */
class CheckItemDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType, UITableViewDelegate {

    typealias Element = List<CheckItem>
    var item = List<CheckItem>()
    private let realm = try! Realm()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckItemTableViewCell", for: indexPath) as! CheckItemTableViewCell
        let element = item[indexPath.row]
        cell.configure(name: element.name, isDone: element.isDone)
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            try! self.realm.write {
                item.remove(at: indexPath.row)
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        case .insert, .none:
            break
        @unknown default:
            break
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 並べ替える処理
        try! realm.write {
            let tmp = item[sourceIndexPath.row]
            item.remove(at: sourceIndexPath.row)
            item.insert(tmp, at: destinationIndexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<RealmSwift.List<CheckItem>>) {
        Binder(self) { dataSource, element in
            dataSource.item = element
        }
        .on(observedEvent)
    }

}

