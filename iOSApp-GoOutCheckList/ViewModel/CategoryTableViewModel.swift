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
    var tableViewItemDeletedObservable: Observable<IndexPath> { get }
    var addCategoryButtonObservable: Observable<Void> { get }
}

// MARK: Outputs
public protocol CategoryTableViewModelOutputs {
    var categoryDataBehaviorRelay: BehaviorRelay<List<Category>> { get }
    var tableViewItemSeletedPublishRelay: PublishRelay<IndexPath> { get }
    var addCategoryButtonPublishRelay: PublishRelay<Void> { get }
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
    internal var tableViewItemDeletedObservable: Observable<IndexPath>
    internal var addCategoryButtonObservable: Observable<Void>

    // MARK: Outputs
    public lazy var categoryDataBehaviorRelay = BehaviorRelay<List<Category>>(value: List<Category>())
    public var tableViewItemSeletedPublishRelay = PublishRelay<IndexPath>()
    var addCategoryButtonPublishRelay = PublishRelay<Void>()

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
    init(tableViewItemSeletedObservable: Observable<IndexPath>,
         tableViewItemDeletedObservable: Observable<IndexPath>,
         addCategoryButtonObservable: Observable<Void>
    ) {
        self.tableViewItemSeletedObservable = tableViewItemSeletedObservable
        self.tableViewItemDeletedObservable = tableViewItemDeletedObservable
        self.addCategoryButtonObservable = addCategoryButtonObservable

        if self.categoryListObjext != nil {
            categoryListObjext = realm.objects(CategoryList.self).first?.list
            self.categoryDataBehaviorRelay
                .accept(categoryListObjext!)
            print("VMの初期値設定、acceptの送信")
        }

        setupBindings()
        setupNotifications()
    }

    // MARK: - Setups
    private func setupBindings() {
        // tableViewが削除された際にRealmからも削除を行う
        tableViewItemDeletedObservable.asObservable()
            .subscribe(onNext: { indexPath in
                let objects = self.realm.objects(Category.self).toArray()
                let object = objects[indexPath.row]
                try! self.realm.write {
                    self.realm.delete(object)
                }
            }).disposed(by: disposeBag)

        tableViewItemSeletedObservable.asObservable()
            .subscribe(onNext: { [weak self] indexPath in
                self?.outputs.tableViewItemSeletedPublishRelay.accept(indexPath)
            }).disposed(by: disposeBag)

        addCategoryButtonObservable.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.outputs.addCategoryButtonPublishRelay.accept(())
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
                    self.categoryListObjext =
                    self.realm.objects(CategoryList.self).first?.list
                } else {
                    self.categoryListObjext!.append(categoryItem)
                }

                self.categoryDataBehaviorRelay
                    .accept(categoryListObjext!)
            }

        }
    }

}
