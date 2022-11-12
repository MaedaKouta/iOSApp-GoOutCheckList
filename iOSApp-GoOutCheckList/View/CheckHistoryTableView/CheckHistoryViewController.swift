//
//  CheckHistoryViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/27.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay
import PKHUD
import RealmSwift
import FloatingPanel

class CheckHistoryViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var nothingTableViewDataImageView: UIImageView!
    @IBOutlet private weak var nothingTableViewLabel: UILabel!

    private let disposeBag = DisposeBag()
    private var checkHistoryDataSource = CheckHistoryDataSource()
    private let realm = try! Realm()
    private let navigationBarButtonSize: CGFloat = 22.5

    // NavigationBarButtonを宣言
    private lazy var settingBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gearshape", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height:25)
        button.addTarget(self, action: #selector(didTapSettingButton(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

    private lazy var checkHistoryViewModel = CheckHistoryViewModel(
        tableViewItemSelectedObservable: tableView.rx.itemSelected.asObservable()
    )

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar()
        checkHistoryViewModel.updateCheckHistoryList()
        displaynothingTableViewData()
        setupTabBarItem()

        tableView.reloadData()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.updateTabBarItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBindings()
    }

    // MARK: Actions
    @objc private func didTapSettingButton(_ sender: UIBarButtonItem) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SettingStoryboard", bundle: nil)

        guard let nc: UINavigationController = storyboard.instantiateInitialViewController(), let settingVC = nc.topViewController as? SettingTableViewController  else {
            return
        }

        self.parent?.navigationController?.pushViewController(settingVC, animated: true)

    }

    // MARK: Setups
    private func setupNavigationBar() {
        self.parent?.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.title = "履歴"
        navigationItem.rightBarButtonItem = settingBarButtonItem
    }

    private func setupTableView() {
        tableView.rowHeight = 50
        tableView.delegate = checkHistoryDataSource
        tableView.register(UINib(nibName: "CheckHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckHistoryTableViewCell")
    }

    private func setupTabBarItem() {
        guard let tabItem = self.tabBarController?.tabBar.items?[1] else {
            return
        }

        tabItem.badgeColor = UIColor.darkGray
        tabItem.badgeValue = nil

    }

    private func setupBindings() {
        // TableViewのデータ連携
        checkHistoryViewModel.outputs.checkHistoryDataBehaviorRelay
            .bind(to: tableView.rx.items(dataSource: checkHistoryDataSource))
            .disposed(by: disposeBag)

        checkHistoryViewModel.outputs.tableViewItemSeletedPublishRelay
            .subscribe { [weak self] indexPath in
                guard let indexPath = indexPath.element else {return}
                let id = self?.checkHistoryDataSource.item[indexPath.row].categoryID
                var dateStringDetail = ""
                var categoryName = ""
                var itemsText = ""

                self?.tableView.deselectRow(at: indexPath, animated: true)

                if let category = self?.findCategoryFromId(categoryId: id)?.name {
                    categoryName = category
                } else {
                    categoryName = "カテゴリー名取得エラー"
                }

                if let date = self?.checkHistoryDataSource.item[indexPath.row].date {
                    dateStringDetail = DateUtils.stringFromDate(date: date, format: "yyyy/MM/dd HH:mm:ss")
                } else {
                    dateStringDetail = "日付取得エラー"
                }

                if let items = self?.checkHistoryDataSource.item[indexPath.row].checkItemList {
                    for item in items {
                        itemsText += "\n"
                        itemsText += item.name
                    }
                } else {
                    itemsText = "エラー：チェックアイテムの取得エラー"
                }

                let alert: UIAlertController = UIAlertController(
                    title: "\(categoryName)",
                    message: """
                    \(dateStringDetail)
                    \(itemsText)
                    """,
                    preferredStyle:  UIAlertController.Style.alert
                )

                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                self?.present(alert, animated: true, completion: nil)

            }.disposed(by: disposeBag)

        tableView.rx.itemDeleted.asObservable()
            .subscribe{ [weak self] _ in
                self?.displaynothingTableViewData()
            }.disposed(by: disposeBag)
    }

    // MARK: Method
    private func displaynothingTableViewData() {
        if checkHistoryDataSource.item.isEmpty {
            nothingTableViewDataImageView.image = UIImage(named: "well_done")

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

    private func findCategoryFromId(categoryId: String?) -> Category? {

        guard let categoryId = categoryId else {
            return nil
        }

        let categoryObject = try! Realm().objects(Category.self)
        let predicate = NSPredicate(format: "id == %@", categoryId)
        let category = categoryObject.filter(predicate).first

        return category
    }

    private func updateTabBarItem() {
        guard let tabItem = self.tabBarController?.tabBar.items?[1] else {
            return
        }
        let checkHistoryObject = realm.objects(CheckHistory.self)
        let noneWatchedCheckHistoryObject = checkHistoryObject.filter{$0.isWatched==false}

        try! self.realm.write() {
            for checkHistory in noneWatchedCheckHistoryObject {
                checkHistory.isWatched = true
            }
        }

        let noneWatchHistoryCount = checkHistoryObject.filter{$0.isWatched == false}.count

        if UserDefaults.standard.bool(forKey: "isDisplayHistoryNumber") {
            if noneWatchHistoryCount == 0 {
                tabItem.badgeColor = UIColor.darkGray
                tabItem.badgeValue = nil
            } else {
                tabItem.badgeColor = UIColor.darkGray
                tabItem.badgeValue = "\(noneWatchHistoryCount)"
            }
        } else {
            tabItem.badgeColor = UIColor.darkGray
            tabItem.badgeValue = nil
        }

    }
}
