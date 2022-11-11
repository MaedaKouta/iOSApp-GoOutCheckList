//
//  CategoryDataSource.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/03.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import RealmSwift

/*
 CategoryTableViewControllerから呼ばれ、TableViewを管理するクラス
 RxSwiftでTableViewを監視するために必要
 */
class CategoryDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType, UITableViewDelegate {

    typealias Element = List<Category>
    var item = List<Category>()
    private let realm = try! Realm()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let element = item[indexPath.row]

        // imageが空だったとき、はてな画像を挿入
        var imageData: Data = (UIImage(named: "question_small")?.pngData())!
        if let image = (UIImage(named: element.assetsImageName)?.pngData()) {
            imageData = image
        }

        cell.configure(category: item[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal,
                                        title: "削除") {(action, view, completionHandler) in

            NotificationCenter.default.post(name: .CategoryViewFromDataSourceDeleteNotification, object: nil, userInfo: ["indexPath": indexPath])
            completionHandler(true)
        }
        let overwriteAction = UIContextualAction(style: .normal,
                                        title: "編集") { (action, view, completionHandler) in
            NotificationCenter.default.post(name: .CategoryViewFromDataSourceOverwriteNotification, object: nil, userInfo: ["indexPath": indexPath])
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        overwriteAction.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, overwriteAction])
        return configuration
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

    func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<RealmSwift.List<Category>>) {
        Binder(self) { dataSource, element in
            dataSource.item = element
        }
        .on(observedEvent)
    }

}

