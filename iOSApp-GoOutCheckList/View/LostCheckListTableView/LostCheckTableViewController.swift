//
//  LostCheckTableViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/07.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

class LostCheckTableViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    var lostCheckDataSource = LostCheckDataSource()
    private lazy var lostCheckViewModel = LostCheckViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
    }

    @IBAction func didTapAddElementButton(_ sender: Any) {
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "LostCheckTableViewCell", bundle: nil), forCellReuseIdentifier: "LostCheckTableViewCell")
    }

    private func setupBindings() {
        lostCheckViewModel.outputs.LostCheckDataBehaviorRelay
            .bind(to: tableView.rx.items(dataSource: lostCheckDataSource))
            .disposed(by: disposeBag)
    }

}
