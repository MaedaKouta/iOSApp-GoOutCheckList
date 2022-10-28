//
//  CheckHistoryViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/27.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay
import PKHUD
import RealmSwift
import FloatingPanel

class CheckHistoryViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var checkHistoryDataSource = CheckHistoryDataSource()
    private let realm = try! Realm()

    private lazy var checkHistoryViewModel = CheckHistoryViewModel(
        tableViewItemSelectedObservable: tableView.rx.itemSelected.asObservable()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "CheckHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckHistoryTableViewCell")
    }

    private func setupBindings() {
        // TableViewのデータ連携
        checkHistoryViewModel.outputs.checkHistoryDataBehaviorRelay
            .bind(to: tableView.rx.items(dataSource: checkHistoryDataSource))
            .disposed(by: disposeBag)

        // TODO: TableViewの再レンダリングにより、色が少しずつ薄くなる挙動にならない
        checkHistoryViewModel.outputs.tableViewItemSeletedPublishRelay
            .subscribe { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }.disposed(by: disposeBag)
    }

}
