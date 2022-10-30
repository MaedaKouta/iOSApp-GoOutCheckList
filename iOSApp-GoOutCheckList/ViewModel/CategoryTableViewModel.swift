//
//  CategoryListViewModel.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/03.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay
import RxRealm
import RealmSwift

// MARK: - Protocol
// MARK: Inputs
public protocol CategoryTableViewModelInputs {
    var tableViewItemSeletedObservable: Observable<IndexPath> { get }
}

// MARK: Outputs
public protocol CategoryTableViewModelOutputs {
    var categoryDataBehaviorRelay: BehaviorRelay<List<Category>> { get }
    var tableViewItemSeletedPublishRelay: PublishRelay<IndexPath> { get }
}

// MARK: InputOutputType
public protocol CategoryTableViewModelType {
  var inputs: CategoryTableViewModelInputs { get }
  var outputs: CategoryTableViewModelOutputs { get }
}

// MARK: - ViewModel
class CategoryTableViewModel: CategoryTableViewModelInputs, CategoryTableViewModelOutputs, CategoryTableViewModelType {

    // MARK: Inputs
    internal var tableViewItemSeletedObservable: Observable<IndexPath>

    // MARK: Outputs
    public lazy var categoryDataBehaviorRelay = BehaviorRelay<List<Category>>(value: List<Category>())
    public var tableViewItemSeletedPublishRelay = PublishRelay<IndexPath>()

    // MARK: InputOutputType
    public var inputs: CategoryTableViewModelInputs { return self }
    public var outputs: CategoryTableViewModelOutputs { return self }

    // MARK: Libraries&Propaties
    private let realm = try! Realm()
    private let disposeBag = DisposeBag()
    private lazy var categoryListObjext = realm.objects(CategoryList.self).first?.list

    // MARK: - Initialize
    /*
     categoryDataBehaviorRelayはCategoryTableViewの要素
     CategoryTableViewModelで初期値設定・管理をする
     */
    init(tableViewItemSeletedObservable: Observable<IndexPath>) {
        self.tableViewItemSeletedObservable = tableViewItemSeletedObservable

        if self.categoryListObjext != nil {
            categoryListObjext = realm.objects(CategoryList.self).first?.list
            self.categoryDataBehaviorRelay
                .accept(categoryListObjext!)
        }

        setupBindings()
        setupNotifications()
    }

    // MARK: - Setups
    private func setupBindings() {

        tableViewItemSeletedObservable.asObservable()
            .subscribe(onNext: { [weak self] indexPath in
                self?.outputs.tableViewItemSeletedPublishRelay.accept(indexPath)
            }).disposed(by: disposeBag)
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fromRegisteCategoryViewCall(notification:)),
            name: NSNotification.Name.CategoryViewFromRegisterViewNotification,
            object: nil)
    }

    // MARK: - Functions
    /*
     RegisterCategoryViewControllerから呼ばれる通知
        遷移先（RegisterCategoryViewController）で登録したCategoryItemを
        遷移元（CategoryTableViewController）に値渡しするために、Notificationが有効だった
        参考：https://qiita.com/star__hoshi/items/41dff8231dd2219de9bd
     */
    @objc func fromRegisteCategoryViewCall(notification: Notification) {
        if let categoryItem = notification.object as? Category {

            // RealmのcategoryListObjextが空だった場合に追加もさせる
            try! self.realm.write() {
                if self.categoryListObjext == nil {
                    let categoryList = CategoryList()
                    categoryList.list.append(categoryItem)
                    self.realm.add(categoryList)
                    self.categoryListObjext = self.realm.objects(CategoryList.self).first?.list
                } else {
                    self.categoryListObjext!.append(categoryItem)
                }

                self.categoryDataBehaviorRelay
                    .accept(categoryListObjext!)
            }

        }
    }

}
