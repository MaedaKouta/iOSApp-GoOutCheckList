//
//  CategoryTableViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/03.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay

class CategoryTableViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addCategoryButton: UIButton!

    private let disposeBag = DisposeBag()
    private var categoryDataSource = CategoryDataSource()

    private lazy var categoryTableViewModel = CategoryTableViewModel(
        addCategoryButtonObservable: addCategoryButton.rx.tap.asObservable()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
    }

    // MARK: TableView
    private func setupBindings() {
        categoryTableViewModel.categoryDataBehaviorRelay
            .bind(to: tableView.rx.items(dataSource: categoryDataSource))
            .disposed(by: disposeBag)
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
    }

}
