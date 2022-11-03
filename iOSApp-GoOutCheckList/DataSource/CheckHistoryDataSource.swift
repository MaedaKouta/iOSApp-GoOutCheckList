//
//  CheckHistoryDataSource.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/27.
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
class CheckHistoryDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

    typealias Element = List<CheckHistory>
    var item = List<CheckHistory>()
    private let realm = try! Realm()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "履歴が50件表示されます"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckHistoryTableViewCell", for: indexPath) as! CheckHistoryTableViewCell
        let element = item[indexPath.row]
        let dateString = DateUtils.stringFromDate(date: element.date, format: "MM/dd HH:mm")
        cell.setConfigure(dateText: dateString, categoryText: element.categoryName, categoryImage: UIImage(named: element.assetsImageName))

        return cell
    }

    func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<RealmSwift.List<CheckHistory>>) {
        Binder(self) { dataSource, element in
            dataSource.item = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }

}
