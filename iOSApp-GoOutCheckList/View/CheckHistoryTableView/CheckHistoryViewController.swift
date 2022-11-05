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

    @IBOutlet private weak var nothingTableViewDataImageView: UIImageView!
    @IBOutlet private weak var nothingTableViewLabel: UILabel!

    private let disposeBag = DisposeBag()
    private var checkHistoryDataSource = CheckHistoryDataSource()
    private let realm = try! Realm()

    private lazy var checkHistoryViewModel = CheckHistoryViewModel(
        tableViewItemSelectedObservable: tableView.rx.itemSelected.asObservable()
    )

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displaynothingTableViewData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupBindings()
    }

    // MARK: Setups
    private func setupNavigationBar() {
        navigationItem.title = "履歴"
    }

    private func setupTableView() {
        tableView.rowHeight = 50
        tableView.delegate = checkHistoryDataSource
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
                guard let indexPath = indexPath.element else {return}
                var dateStringDetail = ""
                var categoryName = ""
                
                self?.tableView.deselectRow(at: indexPath, animated: true)

                if let date = self?.checkHistoryDataSource.item[indexPath.row].date,
                   let category = self?.checkHistoryDataSource.item[indexPath.row].categoryName {
                    dateStringDetail = DateUtils.stringFromDate(date: date, format: "yyyy/MM/dd HH:mm:ss")
                    categoryName = category
                } else {
                    dateStringDetail = "日付取得エラー"
                    categoryName = "カテゴリー名取得エラー"
                }

                let alert: UIAlertController = UIAlertController(
                    title: "\(categoryName)",
                    message: """
                    \(dateStringDetail)
                    """,
                    preferredStyle:  UIAlertController.Style.alert
                )

                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                self?.present(alert, animated: true, completion: nil)

            }.disposed(by: disposeBag)

        tableView.rx.itemDeleted.asObservable()
            .subscribe{ [weak self] _ in
                self?.displaynothingTableViewData()
            }.disposed(by: disposeBag)
    }

    // MARK: Method
    private func displaynothingTableViewData() {
        if checkHistoryDataSource.item.isEmpty {
            nothingTableViewDataImageView.image = UIImage(named: "well_done")

            // アニメーション開始
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.75)
            let transition = CATransition()
            transition.type = CATransitionType.fade
            nothingTableViewDataImageView.layer.add(transition, forKey: kCATransition)
            nothingTableViewDataImageView.isHidden = false
            nothingTableViewLabel.isHidden = false
            CATransaction.commit()

        } else {
            nothingTableViewDataImageView.isHidden = true
            nothingTableViewLabel.isHidden = true
        }
    }

}
