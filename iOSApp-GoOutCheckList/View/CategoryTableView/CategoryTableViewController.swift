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
    private var editButton: UIBarButtonItem!

    // MARK: Propaties
    private let disposeBag = DisposeBag()
    private var categoryDataSource = CategoryDataSource()
    private lazy var categoryTableViewModel = CategoryTableViewModel(
        tableViewItemSeletedObservable: tableView.rx.itemSelected.asObservable(),
        tableViewItemDeletedObservable: tableView.rx.itemDeleted.asObservable(),
        addCategoryButtonObservable: addCategoryButton.rx.tap.asObservable()
    )

    // MARK: Libraries
    private var fpc: FloatingPanelController!
    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        setupNavigationbar()
        setupTableView()
        setupBindings()
        setupFloatingPanel()
    }

    // MARK: Actions
    @objc private func didTapEditButton(_ sender: UIBarButtonItem) {
        tableView.isEditing.toggle()
    }

    // MARK: - Setups
    private func setupBindings() {
        // セルがタップされたときに、次の画面へ遷移させる処理
        //（画面遷移に関わるためViewに書く必要がある）
        categoryTableViewModel.outputs.tableViewItemSeletedPublishRelay
            .subscribe(onNext: { [weak self] indexPath in
                let objects = self?.realm.objects(Category.self).toArray()
                guard let object = objects?[indexPath.row] else { return }
                self?.tableView.deselectRow(at: indexPath, animated: true)
                let checkItemTableVC = CheckItemTableViewController(categoryItemObject: object)
                self?.navigationController?.pushViewController(checkItemTableVC, animated: true)
            })
            .disposed(by: disposeBag)

        categoryTableViewModel.outputs.categoryDataBehaviorRelay
            //.debug()
            .bind(to: tableView.rx.items(dataSource: categoryDataSource))
            .disposed(by: disposeBag)

        categoryTableViewModel.outputs.addCategoryButtonPublishRelay
            .subscribe(onNext: { [weak self] in
                guard let fpc = self?.fpc else { return }
                let view = RegisterCategoryViewController()
                fpc.set(contentViewController: view)
                self?.present(fpc, animated: true, completion: nil)
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

        fpc.isRemovalInteractionEnabled = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        // fpc.surfaceView.grabberHandle.isHidden = true
    }

    private func setupNavigationbar() {
        navigationItem.title = "カテゴリー"
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEditButton(_:)))
        self.navigationItem.rightBarButtonItem = editButton
    }

    // MARK: - test
    public func checkCategoryDataSource() -> CategoryDataSource {
        return self.categoryDataSource
    }

}
