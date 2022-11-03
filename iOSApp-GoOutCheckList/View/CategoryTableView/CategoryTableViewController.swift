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
    @IBOutlet weak var addCategoryButtonView: TouchFeedbackView!

    // NavigationBarButtonを宣言
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

    private lazy var historyBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "clock.arrow.circlepath", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height:25)
        button.addTarget(self, action: #selector(didTapHistoryButton(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

    private lazy var settingBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gearshape.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: navigationBarButtonSize))), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height:25)
        button.addTarget(self, action: #selector(didTapSettingButton(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

    // MARK: Propaties
    private let disposeBag = DisposeBag()
    private var categoryDataSource = CategoryDataSource()
    private var isSelectedHistoryBarButton = false
    private var isSelectedEditingBarButton = false
    private let navigationBarButtonSize: CGFloat = 22.5

    private lazy var categoryTableViewModel = CategoryTableViewModel(
        tableViewItemSeletedObservable: tableView.rx.itemSelected.asObservable()
    )

    // MARK: Libraries
    private var fpc: FloatingPanelController!
    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        addCategoryButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRegisterCategoryButton(_:))))

        setupAddCategoryButton()
        setupNavigationbar()
        setupTableView()
        setupBindings()
        setupFloatingPanel()
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

    @objc private func didTapSettingButton(_ sender: UIBarButtonItem) {
        let storyboard: UIStoryboard = UIStoryboard(name: "SettingStoryboard", bundle: nil)
            if let settingVC = storyboard.instantiateInitialViewController() {
                //self.present(settingVC, animated: true, completion: nil)
                self.navigationController?.pushViewController(settingVC, animated: true)
        }
    }

    // MARK: - Setups
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
                self?.tableView.reloadData()
            }.disposed(by: disposeBag)
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")

        tableView.rowHeight = 50
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
        navigationItem.title = "カテゴリー"
        navigationItem.leftBarButtonItem = settingBarButtonItem

        navigationItem.setRightBarButtonItems(
            [historyBarButtonItem, editBarButtonItem],
            animated: true)

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

    private func setupAddCategoryButton() {
        let image = UIImageView(image: UIImage(systemName: "plus"))
        image.frame = CGRect(x: 22, y: 22, width: 31, height: 31)

        addCategoryButtonView.backgroundColor = UIColor.white
        addCategoryButtonView.tintColor = .darkGray
        addCategoryButtonView.addSubview(image)
        addCategoryButtonView.layer.cornerRadius = 37.5
        addCategoryButtonView.layer.shadowColor = UIColor.black.cgColor
        addCategoryButtonView.layer.shadowRadius = 10
        addCategoryButtonView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        addCategoryButtonView.layer.shadowOpacity = 0.35
    }

    // MARK: - Test
    public func checkCategoryDataSource() -> CategoryDataSource {
        return self.categoryDataSource
    }

}
