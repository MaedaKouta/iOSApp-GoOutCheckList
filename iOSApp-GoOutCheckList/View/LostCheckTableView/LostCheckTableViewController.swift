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
import FloatingPanel

class LostCheckTableViewController: UIViewController, FloatingPanelControllerDelegate {

    // MARK: Actions
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Propaties
    private var lostCheckDataSource = LostCheckDataSource()
    private lazy var lostCheckViewModel = LostCheckViewModel(
        tableViewItemDeletedObservable: tableView.rx.itemDeleted.asObservable(),
        categoryItemObject: categoryItemObject
    )
    private let disposeBag = DisposeBag()
    private var categoryItemObject: CategoryItem

    // MARK: Libraries
    private var fpc: FloatingPanelController!

    // MARK: - Initialize
    init(categoryItemObject: CategoryItem) {
        self.categoryItemObject = categoryItemObject
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = categoryItemObject.name

        setupTableView()
        setupBindings()
        setupFloatingPanel()
    }

    // MARK: - Actions
    @IBAction func didTapAddElementButton(_ sender: Any) {
        let view = RegisterCheckElementViewController()
        fpc.set(contentViewController: view)
        self.present(fpc, animated: true, completion: nil)
    }

    // MARK: - Setups
    private func setupTableView() {
        tableView.register(UINib(nibName: "LostCheckTableViewCell", bundle: nil), forCellReuseIdentifier: "LostCheckTableViewCell")
    }

    private func setupBindings() {
        lostCheckViewModel.outputs.LostCheckDataBehaviorRelay
            .bind(to: tableView.rx.items(dataSource: lostCheckDataSource))
            .disposed(by: disposeBag)

        // セルがタップされたときに、灰色を消す
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupFloatingPanel() {
        fpc = FloatingPanelController(delegate: self)
        fpc.layout = RegisterCheckElementFloatingPanelLayout()
        fpc.isRemovalInteractionEnabled = true
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 24.0
        fpc.surfaceView.appearance = appearance
    }

}
