//
// LostCheckTableViewController.swift
// iOSApp-GoOutCheckList
//
// Created by 前田航汰 on 2022/10/07.
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
    @IBOutlet private weak var addItemButtonView: TouchFeedbackView!
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()


    // MARK: Propaties
    private var checkItemDataSource = CheckItemDataSource()
    private lazy var checkItemViewModel = CheckItemViewModel(
        tableViewItemSeletedObservable: tableView.rx.itemSelected.asObservable(),
        categoryObject: categoryObject
    )
    private let navigationBarButtonSize: CGFloat = 22.5
    private var isSelectedEditingBarButton = false
    private let realm = try! Realm()
    private let disposeBag = DisposeBag()
    private var categoryObject: Category
    private lazy var checkHistoryListObject = realm.objects(CheckHistoryList.self).first

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
        setupAddItemButton()
    }

    // MARK: Actions
    @objc private func didTapEditButton(_ sender: UIBarButtonItem) {
        if checkItemDataSource.item.count != 0 {
            isSelectedEditingBarButton.toggle()
        } else {
            isSelectedEditingBarButton = false
        }
        setEditBarButtonItemIcon(isSelected: isSelectedEditingBarButton)
    }

    @objc private func didTapRegisterItemButton(_ sender: UIBarButtonItem) {
        // カテゴリー追加時には編集モードをオフにする
        isSelectedEditingBarButton = false
        setEditBarButtonItemIcon(isSelected: isSelectedEditingBarButton)
        guard let fpc = self.fpc else { return }
        let view = RegisterCheckItemViewController()
        fpc.set(contentViewController: view)
        self.present(fpc, animated: true, completion: nil)
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
                        let checkHistoryObject = CheckHistory()
                        checkHistoryObject.date = Date()
                        checkHistoryObject.categoryName = self?.categoryObject.name ?? ""
                        checkHistoryObject.assetsImageName = self?.categoryObject.assetsImageName ?? "question_small"

                        // リストがなければ、リストを作る（初期に作る必要が出てくる）
                        if self?.checkHistoryListObject == nil {
                            let checkHistoryList = CheckHistoryList()
                            checkHistoryList.checkHistoryList.append(checkHistoryObject)
                            self?.realm.add(checkHistoryList)
                            self?.checkHistoryListObject = self?.realm.objects(CheckHistoryList.self).first
                        } else {
                            if 50 <= self?.checkHistoryListObject!.checkHistoryList.count ?? 0 {
                                // 先頭のCheckHistoryを取得して、削除する
                                let checkHistory = self?.realm.objects(CheckHistory.self)
                                let id = self?.checkHistoryListObject?.checkHistoryList.last?.id ?? ""
                                let predicate = NSPredicate(format: "id == %@", id)
                                let removeCheckHistory = checkHistory?.filter(predicate).first
                                if let removeCheckHistory = removeCheckHistory {
                                    self?.realm.delete(removeCheckHistory)
                                }
                            }
                            self?.checkHistoryListObject?.checkHistoryList.insert(checkHistoryObject, at: 0)
                        }
                    }
                }
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

    private func setupAddItemButton() {
        addItemButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRegisterItemButton(_:))))
        let image = UIImageView(image: UIImage(systemName: "plus"))
        image.frame = CGRect(x: 22, y: 22, width: 31, height: 31)
        addItemButtonView.backgroundColor = UIColor.white
        addItemButtonView.tintColor = .darkGray
        addItemButtonView.addSubview(image)
        addItemButtonView.layer.cornerRadius = 37.5
        addItemButtonView.layer.shadowColor = UIColor.black.cgColor
        addItemButtonView.layer.shadowRadius = 10
        addItemButtonView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        addItemButtonView.layer.shadowOpacity = 0.35
    }

    private func setupNavigationbar() {
        navigationItem.title = categoryObject.name
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }

    // MARK: Method
    private func setEditBarButtonItemIcon(isSelected: Bool) {
        if isSelected {
            editBarButtonItem = {
                let button = UIButton(type: .custom)
                button.setImage(UIImage(systemName: "pencil.slash", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
                button.frame = CGRect(x: 0, y: 0, width: 25, height:25)
                button.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
                return UIBarButtonItem(customView: button)
            }()
        } else {
            editBarButtonItem = {
                let button = UIButton(type: .custom)
                button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
                button.frame = CGRect(x: 0, y: 0, width: 25, height:25)
                button.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
                return UIBarButtonItem(customView: button)
            }()
        }

        tableView.setEditing(isSelected, animated: true)
        setupNavigationbar()
    }
}
