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
    private let realm = RealmManager().realm

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if item.isEmpty {
            return nil
        } else {
            return "履歴が100件表示されます"
        }
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let checkHistoryObject = realm.objects(CheckHistory.self)
            let predicate = NSPredicate(format: "id == %@", item[indexPath.row].id)
            let deleteCheckHistory = checkHistoryObject.filter(predicate).first

            try! self.realm.write {
                guard let deleteCheckHistory = deleteCheckHistory else{
                    return
                }
                realm.delete(deleteCheckHistory)
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckHistoryTableViewCell", for: indexPath) as! CheckHistoryTableViewCell
        let element = item[indexPath.row]

        // categoryObjectからelement.idを探す
        let dateString = DateUtils.stringFromDate(date: element.date, format: "MM/dd HH:mm")
        cell.setConfigure(dateText: dateString, categoryId: element.categoryID, isWatched: element.isWatched)

        return cell
    }

    func tableView(_ tableView: UITableView, observedEvent: RxSwift.Event<RealmSwift.List<CheckHistory>>) {
        Binder(self) { dataSource, element in
            dataSource.item = element
        }
        .on(observedEvent)
    }
}
