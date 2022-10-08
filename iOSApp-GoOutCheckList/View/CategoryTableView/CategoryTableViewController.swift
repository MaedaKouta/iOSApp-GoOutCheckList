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

class CategoryTableViewController: UIViewController, FloatingPanelControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var addCategoryButton: UIButton!

    // MARK: Propaties
    private let disposeBag = DisposeBag()
    private var categoryDataSource = CategoryDataSource()
    private lazy var categoryTableViewModel = CategoryTableViewModel(
        tableViewItemDeletedObservable: tableView.rx.itemDeleted.asObservable()
    )

    // MARK: Libraries
    private var fpc: FloatingPanelController!
    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        navigationItem.title = "カテゴリー"

        setupTableView()
        setupBindings()
        setupFloatingPanel()
    }

    // MARK: - Action
    // 画面遷移
    //（画面遷移に関わるためViewに書く必要がある）
    @IBAction private func didTapAddCcategoryButton(_ sender: Any) {
        let view = RegisterCategoryDetailViewController()
        fpc.set(contentViewController: view)
        self.present(fpc, animated: true, completion: nil)
    }

    // MARK: - Setups
    private func setupBindings() {
        // セルがタップされたときに、次の画面へ遷移させる処理
        //（画面遷移に関わるためViewに書く必要がある）
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let objects = self.realm.objects(CategoryItem.self).toArray()
                let object = objects[indexPath.row]
                self.tableView.deselectRow(at: indexPath, animated: true)
                let lostCheckTableVC = LostCheckTableViewController(categoryItemObject: object)
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
