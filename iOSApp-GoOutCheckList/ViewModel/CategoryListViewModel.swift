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
    var tableViewItemDeletedObservable: Observable<IndexPath> { get }
}

// MARK: Outputs
public protocol CategoryTableViewModelOutputs {
    var categoryDataBehaviorRelay: BehaviorRelay<[CategoryItem]> { get }
}

// MARK: InputOutputType
public protocol CategoryTableViewModelType {
  var inputs: CategoryTableViewModelInputs { get }
  var outputs: CategoryTableViewModelOutputs { get }
}

// MARK: - ViewModel
class CategoryTableViewModel: CategoryTableViewModelInputs, CategoryTableViewModelOutputs, CategoryTableViewModelType {

    // MARK: Inputs
    internal var tableViewItemDeletedObservable: Observable<IndexPath>

    // MARK: Outputs
    public lazy var categoryDataBehaviorRelay = BehaviorRelay<[CategoryItem]>(value: realm.objects(CategoryItem.self).toArray())

    // MARK: InputOutputType
    public var inputs: CategoryTableViewModelInputs { return self }
    public var outputs: CategoryTableViewModelOutputs { return self }

    // MARK: Libraries&Propaties
    private let realm = try! Realm()
    private let disposeBag = DisposeBag()

    // MARK: - Initialize
    /*
     categoryDataBehaviorRelayはCategoryTableViewの要素
     CategoryTableViewModelで初期値設定・管理をする
     */
    init(tableViewItemDeletedObservable: Observable<IndexPath>) {
        self.tableViewItemDeletedObservable = tableViewItemDeletedObservable
        categoryDataBehaviorRelay.accept(realm.objects(CategoryItem.self).toArray())

        setupBindings()
        setupNotifications()
    }

    // MARK: - Setups
    private func setupBindings() {
        // tableViewが削除された際にRealmからも削除を行う
        tableViewItemDeletedObservable.asObservable()
            .subscribe(onNext: { indexPath in
                let objects = self.realm.objects(CategoryItem.self).toArray()
                let object = objects[indexPath.row]
                try! self.realm.write {
                    self.realm.delete(object)
                }
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
     RegisterCategoryDetailViewControllerから呼ばれる通知
        遷移先（RegisterCategoryDetailViewController）で登録したCategoryItemを
        遷移元（CategoryTableViewController）に値渡しするために、Notificationが有効だった
        参考：https://qiita.com/star__hoshi/items/41dff8231dd2219de9bd
     */
    @objc func fromRegisteCategoryViewCall(notification: Notification) {
        if let categoryItem = notification.object as? CategoryItem {
            try! realm.write {
                realm.add(categoryItem)
                self.categoryDataBehaviorRelay.accept(realm.objects(CategoryItem.self).toArray())
            }
        }
    }

}
