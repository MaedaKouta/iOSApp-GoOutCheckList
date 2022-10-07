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
import FloatingPanel

class CategoryTableViewController: UIViewController, FloatingPanelControllerDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addCategoryButton: UIButton!
    var fpc: FloatingPanelController!

    private let disposeBag = DisposeBag()
    private var categoryDataSource = CategoryDataSource()

    private lazy var categoryTableViewModel = CategoryTableViewModel(
        addCategoryButtonObservable: addCategoryButton.rx.tap.asObservable()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        setupFloatingPanel()

        let view = RegisterCategoryDetailViewController()
        fpc.set(contentViewController: view)
        self.present(fpc, animated: true, completion: nil)
    }

    // MARK: TableView
    private func setupBindings() {
        categoryTableViewModel.categoryDataBehaviorRelay
            .bind(to: tableView.rx.items(dataSource: categoryDataSource))
            .disposed(by: disposeBag)

        // セルが削除されたときに、ViewModelにも反映させる処理
        tableView.rx.itemDeleted
            .subscribe(onNext: { indexPath in
                self.categoryTableViewModel.categoryList.remove(at: indexPath.row)
            }).disposed(by: disposeBag)
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
    }

    private func setupFloatingPanel() {
        fpc = FloatingPanelController(delegate: self)
        fpc.layout = RegisterCategoryDetailFloatingPanelLayout()
        fpc.isRemovalInteractionEnabled = true
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 24.0
        fpc.surfaceView.appearance = appearance
    }

}
