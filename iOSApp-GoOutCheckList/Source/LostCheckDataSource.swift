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

class LostCheckDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

    typealias Element = [CheckItem]
    var item: [CheckItem] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LostCheckTableViewCell", for: indexPath)
        let element = item[indexPath.row]
        cell.textLabel?.text = element.name
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            item.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        case .insert, .none:
            break
        @unknown default:
            break
        }
    }

    func tableView(_ tableView: UITableView, observedEvent: Event<[CheckItem]>) {
        Binder(self) { dataSource, element in
            dataSource.item = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }

}

