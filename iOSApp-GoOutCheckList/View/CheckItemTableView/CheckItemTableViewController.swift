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
    @IBOutlet private weak var nothingTableViewDataImageView: UIImageView!
    @IBOutlet private weak var nothingTableViewLabel: UILabel!
    @IBOutlet private weak var checkedProgressView: UIProgressView!
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    private let userdefaultManager = UserdefaultsManager()


    private lazy var editBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down.circle", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

    private lazy var allCheckBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "text.badge.checkmark", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(didTapAllCheckButton(_:)), for: .touchUpInside)
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
    private let realm = RealmManager().realm
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        displaynothingTableViewData()
        updateNavigationbar()
        updateProgressView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationbar()
        setupTableView()
        setupBindings()
        setupFloatingPanel()
        setupAddItemButton()
        setupNotifications()
    }

    // MARK: Actions
    @objc private func selectedCellDelete(notification: NSNotification?) {
        guard let indexPath = notification?.userInfo!["indexPath"] as? IndexPath else {
            return
        }
        cellDeletedAlert(indexPath: indexPath)
    }

    @objc private func selectedCellOverwrite(notification: NSNotification?) {
        guard let indexPath = notification?.userInfo!["indexPath"] as? IndexPath else {
            return
        }

        // カテゴリー追加時には編集モードをオフにする
        isSelectedEditingBarButton = false
        setEditBarButtonItemIcon(isSelected: isSelectedEditingBarButton)
        guard let fpc = self.fpc else { return }
        let view = CheckItemEditViewController(itemName: checkItemDataSource.item[indexPath.row].name, index: indexPath.row)
        fpc.set(contentViewController: view)
        self.present(fpc, animated: true, completion: nil)
    }

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

    @objc private func didTapAllCheckButton(_ sender: UIBarButtonItem) {
        // 全てのアイテムを選択する
        let alert: UIAlertController = UIAlertController(
            title: "",
            message: """
            全てのアイテムを完了にします。よろしいですか？
            """,
            preferredStyle:  UIAlertController.Style.alert
        )

        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ [weak self]
            (action: UIAlertAction!) -> Void in

            self?.checkItemViewModel.setAllItemSelect()

        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)

    }

    // MARK: - Setups
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectedCellDelete(notification:)), name: .CheckItemViewFromDataSourceDeleteNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(selectedCellOverwrite(notification:)), name: .CheckItemViewFromDataSourceOverwriteNotification, object: nil)
    }

    private func setupTableView(){
        tableView.rowHeight = 47.5
        tableView.delegate = checkItemDataSource
        tableView.register(UINib(nibName: "CheckItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckItemTableViewCell")
    }

    private func setupBindings() {
        // TableViewのデータ連携
        checkItemViewModel.outputs.CheckItemDataBehaviorRelay
            .bind(to: tableView.rx.items(dataSource: checkItemDataSource))
            .disposed(by: disposeBag)

        checkItemViewModel.outputs.tableViewItemSeletedPublishRelay
            .subscribe { [weak self] indexPath in
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                self?.updateProgressView()
            }.disposed(by: disposeBag)

        checkItemViewModel.outputs.addItemPublishRelay
            .subscribe { [weak self] _ in
                self?.tableView.reloadData()
                self?.displaynothingTableViewData()
                self?.updateNavigationbar()
                self?.updateProgressView()
            }.disposed(by: disposeBag)

        // 全てチェックされたらPKHUDを表示
        checkItemViewModel.outputs.allItemSelectedPublishSubject
            .subscribe{ [weak self] _ in

                guard let categoryObject = self?.categoryObject else {
                    return
                }

                HUD.flash(.success, onView: self?.view, delay: 1.0)
                self?.feedbackGenerator.notificationOccurred(.success)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.navigationController?.popViewController(animated: true)
                    try! self?.realm.write {
                        self?.categoryObject.checkItems.forEach{ $0.isDone = false }

                        let checkHistoryObject = CheckHistory()
                        checkHistoryObject.date = Date()
                        checkHistoryObject.categoryID = categoryObject.id
                        checkHistoryObject.checkItemList = categoryObject.checkItems

                        // リストがなければ、リストを作る（初期に作る必要が出てくる）
                        if self?.checkHistoryListObject == nil {
                            let checkHistoryList = CheckHistoryList()
                            checkHistoryList.checkHistoryList.append(checkHistoryObject)
                            self?.realm.add(checkHistoryList)
                            self?.checkHistoryListObject = self?.realm.objects(CheckHistoryList.self).first
                        } else {
                            if 100 < self?.checkHistoryListObject!.checkHistoryList.count ?? 0 {
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

                    self?.updateTabBarItem()
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
        self.navigationItem.rightBarButtonItems = [editBarButtonItem, allCheckBarButtonItem]
        updateNavigationbar()
    }

    // MARK: Updates
    private func updateNavigationbar() {
        // アイテムが１つ以下だったら並べ替えボタンタップできなくする
        if checkItemDataSource.item.isEmpty {
            navigationItem.rightBarButtonItems?[0].isEnabled = false
            navigationItem.rightBarButtonItems?[1].isEnabled = false
        } else {
            navigationItem.rightBarButtonItems?[0].isEnabled = true
            navigationItem.rightBarButtonItems?[1].isEnabled = true
        }
    }

    private func updateProgressView() {

        // メインスレッドで実行させないと、allItemCheckButtonの際のprogressViewアニメーションが激速になる
        DispatchQueue.main.async {

            let allItemsCount = self.checkItemDataSource.item.count
            let chekedItemsCount = self.checkItemDataSource.item.filter{ $0.isDone }.count
            let chekedRatio: Float = Float(chekedItemsCount)/Float(allItemsCount)

            // allItemsが空ならprogressView表示させない
            if allItemsCount == 0 {
                self.checkedProgressView.setProgress(0.0, animated: true)
            } else {
                self.checkedProgressView.setProgress(chekedRatio, animated: true)
            }
        }

    }

    // MARK: Method
    private func setEditBarButtonItemIcon(isSelected: Bool) {
        if isSelected {
            editBarButtonItem = {
                let button = UIButton(type: .custom)
                button.setImage(UIImage(systemName: "arrow.up.arrow.down.circle.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
                button.frame = CGRect(x: 0, y: 0, width: 25, height:25)
                button.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
                return UIBarButtonItem(customView: button)
            }()
        } else {
            editBarButtonItem = {
                let button = UIButton(type: .custom)
                button.setImage(UIImage(systemName: "arrow.up.arrow.down.circle", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
                button.frame = CGRect(x: 0, y: 0, width: 25, height:25)
                button.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
                return UIBarButtonItem(customView: button)
            }()
        }

        tableView.setEditing(isSelected, animated: true)
        setupNavigationbar()
    }

    // MARK: Method
    private func displaynothingTableViewData() {
        if checkItemDataSource.item.isEmpty {
            nothingTableViewDataImageView.image = UIImage(named: "item_nothing")

            // アニメーション開始
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.75)
            let transition = CATransition()
            transition.type = CATransitionType.fade
            nothingTableViewDataImageView.layer.add(transition, forKey: kCATransition)
            nothingTableViewDataImageView.isHidden = false
            nothingTableViewLabel.isHidden = false
            CATransaction.commit()

        } else {
            nothingTableViewDataImageView.isHidden = true
            nothingTableViewLabel.isHidden = true
        }
    }

    private func cellDeletedAlert(indexPath: IndexPath) {
        let alert: UIAlertController = UIAlertController(
            title: "",
            message: """
            \(checkItemDataSource.item[indexPath.row].name)のアイテムを削除します。よろしいですか？
            """,
            preferredStyle:  UIAlertController.Style.alert
        )

        let okAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.destructive, handler:{ [weak self]
            (action: UIAlertAction!) -> Void in
            try! self?.realm.write {
                self?.checkItemDataSource.item.remove(at: indexPath.row)
            }
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [indexPath], with: .top)
            self?.tableView.endUpdates()

            self?.displaynothingTableViewData()
            self?.updateNavigationbar()
            self?.checkItemViewModel.setDeletedItem()
            self?.updateProgressView()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    private func updateTabBarItem() {
        print(userdefaultManager.getIsDisplayHistoryNumber())
        if userdefaultManager.getIsDisplayHistoryNumber() == true {
            let checkHistoryListObject = realm.objects(CheckHistoryList.self).first
            let noneWatchHistoryCount = checkHistoryListObject?.checkHistoryList.filter{$0.isWatched == false}.count ?? 0
            if noneWatchHistoryCount == 0 {return}

            if let tabItem = self.tabBarController?.tabBar.items?[1] {
                tabItem.badgeColor = UIColor.darkGray
                tabItem.badgeValue = "\(noneWatchHistoryCount)"
            }
        }
    }

}
