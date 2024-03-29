import UIKit
import RxCocoa
import RxSwift
import RxRelay
import FloatingPanel
import RealmSwift
import StoreKit

class CategoryTableViewController: UIViewController, FloatingPanelControllerDelegate, UITableViewDelegate {
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCategoryButtonView: TouchFeedbackView!
    @IBOutlet private weak var nothingTableViewDataImageView: UIImageView!
    @IBOutlet private weak var nothingTableViewLabel: UILabel!
    private let userdefaultManager = UserdefaultsManager()

    // NavigationBarButtonを宣言
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down.circle", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

    // MARK: Propaties
    private let disposeBag = DisposeBag()
    private let realm = RealmManager().realm
    private var categoryDataSource = CategoryDataSource()
    private var isSelectedHistoryBarButton = false
    private var isSelectedEditingBarButton = false
    private let navigationBarButtonSize: CGFloat = 22.5
    private let categoryListObject = RealmManager().realm.objects(CategoryList.self)

    private lazy var categoryTableViewModel = CategoryTableViewModel(
        tableViewItemSeletedObservable: tableView.rx.itemSelected.asObservable()
    )

    // MARK: Libraries
    private var fpc: FloatingPanelController!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationbar()
        categoryTableViewModel.updateCategoryList()
        displaynothingTableViewData()
        updateTabBarItem()
        // チェックから戻ってきたとき&&指定した条件で、簡易レビュー画面を出す
        if userdefaultManager.getBool(forKey: .shouldShowReview) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
            userdefaultManager.set(false, forKey: .shouldShowReview)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print(Realm.Configuration.defaultConfiguration.fileURL!)

        addCategoryButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRegisterCategoryButton(_:))))

        setDisplayFromWidget()
        setupAddCategoryButton()
        setupTableView()
        setupBindings()
        setupFloatingPanel()
        setupNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isSelectedEditingBarButton = false
        setEditBarButtonItemIcon(isSelected: isSelectedEditingBarButton)
    }

    // MARK: Actions
    @objc private func didTapRegisterCategoryButton(_ sender: UIBarButtonItem) {
        // カテゴリー追加時には編集モードをオフにする
        isSelectedEditingBarButton = false
        setEditBarButtonItemIcon(isSelected: isSelectedEditingBarButton)

        guard let fpc = self.fpc else { return }
        let view = RegisterCategoryViewController()
        fpc.set(contentViewController: view)
        self.present(fpc, animated: true, completion: nil)
    }

    @objc private func didTapEditButton(_ sender: UIBarButtonItem) {
        // 値がからのときは編集ボタンを押せなくする
        if categoryDataSource.item.count != 0 {
            isSelectedEditingBarButton.toggle()
        } else {
            isSelectedEditingBarButton = false
        }
        setEditBarButtonItemIcon(isSelected: isSelectedEditingBarButton)
    }

    @objc private func didTapHistoryButton(_ sender: UIBarButtonItem) {
        let checkHistoryTableVC = CheckHistoryViewController()
        self.navigationController?.pushViewController(checkHistoryTableVC, animated: true)
    }

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
        let view = CategoryEditViewController(categoryName: categoryDataSource.item[indexPath.row].name, categoryImageName: categoryDataSource.item[indexPath.row].assetsImageName, index: indexPath.row)
        fpc.set(contentViewController: view)
        self.present(fpc, animated: true, completion: nil)

    }

    // MARK: - Setups
    private func setDisplayFromWidget() {
        if userdefaultManager.getIsDisplayFromWidget() {

            guard let topCategory = realm.objects(CategoryList.self).first?.list.first else {
                userdefaultManager.setIsDisplayFromWidget(isTrue: false)
                return
            }

            // カテゴリーIDからTableViewのインデックスを調べる
            let categoryId = userdefaultManager.getWidgetCategoryId()
            print(categoryId)
            let categoryObject = realm.objects(Category.self)
            let predicate = NSPredicate(format: "id == %@", categoryId)
            let category = categoryObject.filter(predicate).first ?? topCategory

            // 調べたカテゴリーIDでセルをタップさせて画面遷移する
            let checkItemTableVC = CheckItemTableViewController(categoryItemObject: category)
            self.navigationController?.pushViewController(checkItemTableVC, animated: true)
        }

        userdefaultManager.setIsDisplayFromWidget(isTrue: false)
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectedCellDelete(notification:)), name: .CategoryViewFromDataSourceDeleteNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(selectedCellOverwrite(notification:)), name: .CategoryViewFromDataSourceOverwriteNotification, object: nil)
    }

    private func setupBindings() {
        // セルがタップされたときに、次の画面へ遷移させる処理
        //（画面遷移に関わるためViewに書く必要がある）
        categoryTableViewModel.outputs.tableViewItemSeletedPublishRelay
            .subscribe(onNext: { [weak self] indexPath in

                let objects = self?.realm.objects(CategoryList.self)
                guard let object = objects?.first?.list[indexPath.row] else { return }
                self?.tableView.deselectRow(at: indexPath, animated: true)
                let checkItemTableVC = CheckItemTableViewController(categoryItemObject: object)
                self?.navigationController?.pushViewController(checkItemTableVC, animated: true)

            })
            .disposed(by: disposeBag)

        categoryTableViewModel.outputs.categoryDataBehaviorRelay
            .bind(to: tableView.rx.items(dataSource: categoryDataSource))
            .disposed(by: disposeBag)

        categoryTableViewModel.outputs.addCategoryPublishRelay
            .subscribe{ [weak self] _ in
                self?.displaynothingTableViewData()
                self?.tableView.reloadData()
                self?.setEditBarButtonItemIcon(isSelected: false)
            }.disposed(by: disposeBag)

        tableView.rx.itemDeleted.asObservable()
            .subscribe{ [weak self] _ in
                self?.displaynothingTableViewData()
                self?.setEditBarButtonItemIcon(isSelected: false)
            }.disposed(by: disposeBag)
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        tableView.delegate = categoryDataSource
        tableView.rowHeight = 70
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
    }

    private func setupNavigationbar() {
        self.parent?.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.title = "カテゴリー"
        navigationItem.rightBarButtonItem = editBarButtonItem

        // カテゴリーが１つ以下だったら並べ替えボタンタップできなくする
        if categoryDataSource.item.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    private func setupAddCategoryButton() {
        let image = UIImageView(image: UIImage(systemName: "plus"))
        image.frame = CGRect(x: 17, y: 17, width: 26, height: 26)
        image.tintColor = UIColor.customButtonTextColor

        addCategoryButtonView.backgroundColor = UIColor.customButtonBackGroundColor
        addCategoryButtonView.addSubview(image)
        addCategoryButtonView.layer.cornerRadius = 30
        addCategoryButtonView.layer.shadowColor = UIColor.label.cgColor
        addCategoryButtonView.layer.shadowRadius = 10
        addCategoryButtonView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        addCategoryButtonView.layer.shadowOpacity = 0.35
    }

    // MARK: Method
    private func updateTabBarItem() {
        if userdefaultManager.getIsDisplayHistoryNumber() {
            let checkHistoryListObject = realm.objects(CheckHistoryList.self).first
            let noneWatchHistoryCount = checkHistoryListObject?.checkHistoryList.filter{$0.isWatched == false}.count ?? 0
            if noneWatchHistoryCount == 0 {return}

            if let tabItem = self.tabBarController?.tabBar.items?[1] {
                tabItem.badgeColor = UIColor.darkGray
                tabItem.badgeValue = "\(noneWatchHistoryCount)"
            }
        }
    }

    private func displaynothingTableViewData() {
        if categoryDataSource.item.isEmpty {
            nothingTableViewDataImageView.image = UIImage(named: "day_off")

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

    private func cellDeletedAlert(indexPath: IndexPath) {
        let alert: UIAlertController = UIAlertController(
            title: "",
            message: """
            \(categoryDataSource.item[indexPath.row].name)のカテゴリーを削除します。よろしいですか？
            履歴も完全に削除されます。
            """,
            preferredStyle:  UIAlertController.Style.alert
        )

        let okAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.destructive, handler:{
                (action: UIAlertAction!) -> Void in

            // 削除するCheckHistoryを複数取得
            let categoryObject = self.realm.objects(CheckHistory.self)
            let predicate = NSPredicate(format: "categoryID == %@", self.categoryDataSource.item[indexPath.row].id)
            let deleteCheckHistoryList = categoryObject.filter(predicate)

            try! self.realm.write {
                self.realm.delete(deleteCheckHistoryList)
                self.realm.delete(self.categoryDataSource.item[indexPath.row].checkItems)
                self.realm.delete(self.categoryDataSource.item[indexPath.row])
            }
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .top)
            self.tableView.endUpdates()

            self.updateTabBarItem()
            self.displaynothingTableViewData()
            self.setEditBarButtonItemIcon(isSelected: false)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }

    // MARK: - Test
    public func checkCategoryDataSource() -> CategoryDataSource {
        return self.categoryDataSource
    }
}
