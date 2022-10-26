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
    private var categoryDataSource = CategoryDataSource()
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "CheckHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckHistoryTableViewCell")
    }

}
