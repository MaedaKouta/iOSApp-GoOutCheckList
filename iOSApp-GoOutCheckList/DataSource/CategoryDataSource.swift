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
class CategoryDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

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
        if let image = element.imageData {
            imageData = image
        }

        cell.configure(image: UIImage(data: imageData), name: element.name)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            try! self.realm.write {
                realm.delete(item[indexPath.row].checkItems)
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

    func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<RealmSwift.List<Category>>) {
        Binder(self) { dataSource, element in
            dataSource.item = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }

}

