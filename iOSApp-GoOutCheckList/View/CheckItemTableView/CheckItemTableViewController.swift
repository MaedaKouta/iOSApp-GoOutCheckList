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
import PKHUD
import RealmSwift
import FloatingPanel

class CheckItemTableViewController: UIViewController, FloatingPanelControllerDelegate {

    // MARK: Actions
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItemButton: UIButton!
    private var editButton: UIBarButtonItem!

    // MARK: Propaties
    private var checkItemDataSource = CheckItemDataSource()
    private lazy var checkItemViewModel = CheckItemViewModel( tableViewItemSeletedObservable: tableView.rx.itemSelected.asObservable(), addItemButtonObservable: addItemButton.rx.tap.asObservable(),
        categoryObject: categoryObject
    )
    private let realm = try! Realm()
    private let disposeBag = DisposeBag()
    private var categoryObject: Category

    // MARK: Libraries
    private var fpc: FloatingPanelController!

    // MARK: - Initialize
    init(categoryItemObject: Category) {
        self.categoryObject = categoryItemObject
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
    private func setupTableView() {
        tableView.register(UINib(nibName: "CheckItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckItemTableViewCell")
    }

    private func setupBindings() {

        // TableViewのデータ連携
        checkItemViewModel.outputs.CheckItemDataBehaviorRelay
            .bind(to: tableView.rx.items(dataSource: checkItemDataSource))
            .disposed(by: disposeBag)

        // TODO: TableViewの再レンダリングにより、色が少しずつ薄くなる挙動にならない
        checkItemViewModel.outputs.tableViewItemSeletedPublishRelay
            .subscribe { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }.disposed(by: disposeBag)

        // 全てチェックされたらPKHUDを表示
        checkItemViewModel.outputs.allItemSelectedPublishSubject
            .subscribe{ [weak self] _ in
                HUD.flash(.success, onView: self?.view, delay: 1.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.navigationController?.popViewController(animated: true)
                    try! self?.realm.write {
                        self?.categoryObject.checkItems.forEach{ $0.isDone = false }
                    }
                }
            }.disposed(by: disposeBag)

        // 右下のItem追加ボタンでモーダル表示
        checkItemViewModel.outputs.addItemButtonPublishRelay
            .subscribe{ [weak self] _ in
                guard let fpc = self?.fpc else { return }
                let view = RegisterCheckItemViewController()
                fpc.set(contentViewController: view)
                self?.present(fpc, animated: true, completion: nil)
            }.disposed(by: disposeBag)

    }

    private func setupFloatingPanel() {
        fpc = FloatingPanelController(delegate: self)
        fpc.layout = RegisterCheckElementFloatingPanelLayout()
        fpc.isRemovalInteractionEnabled = true
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 24.0
        fpc.surfaceView.appearance = appearance

        fpc.isRemovalInteractionEnabled = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        // fpc.surfaceView.grabberHandle.isHidden = true
    }

    private func setupNavigationbar() {
        navigationItem.title = categoryObject.name
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEditButton(_:)))
        self.navigationItem.rightBarButtonItem = editButton
    }

}
