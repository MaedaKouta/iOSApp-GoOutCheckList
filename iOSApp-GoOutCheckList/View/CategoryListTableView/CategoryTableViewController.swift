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
import RealmSwift
import RxRealm

class CategoryTableViewController: UIViewController, FloatingPanelControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var addCategoryButton: UIButton!
    private var fpc: FloatingPanelController!

    private let disposeBag = DisposeBag()
    var categoryDataSource = CategoryDataSource()
    private lazy var categoryTableViewModel = CategoryTableViewModel(
        tableViewItemDeletedObservable: tableView.rx.itemDeleted.asObservable()
    )
    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        setupTableView()
        setupBindings()
        setupFloatingPanel()
    }

    @IBAction private func didTapAddCcategoryButton(_ sender: Any) {
        let view = RegisterCategoryDetailViewController()
        fpc.set(contentViewController: view)
        self.present(fpc, animated: true, completion: nil)
    }

    // MARK: TableView
    private func setupBindings() {
        // セルがタップされたときに、次の画面へ遷移させる処理
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
                let lostCheckTableVC = LostCheckTableViewController()
                self.navigationController?.pushViewController(lostCheckTableVC, animated: true)
            })
            .disposed(by: disposeBag)

        categoryTableViewModel.outputs.categoryDataBehaviorRelay
            .bind(to: tableView.rx.items(dataSource: categoryDataSource))
            .disposed(by: disposeBag)
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
