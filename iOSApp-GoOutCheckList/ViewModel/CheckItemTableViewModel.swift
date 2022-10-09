//
//  LostCheckListViewModel.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/07.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay
import RxRealm
import RealmSwift

// MARK: - Protocol
// MARK: Inputs
public protocol CheckItemViewModelInputs {
    var tableViewItemDeletedObservable: Observable<IndexPath> { get }
    var categoryItemObject: Category { get }
}

// MARK: Outputs
public protocol CheckItemViewModelOutputs {
    var LostCheckDataBehaviorRelay: BehaviorRelay<List<CheckItem>> { get }
}

// MARK: InputOutputType
public protocol CheckItemViewModelType {
  var inputs: CheckItemViewModelInputs { get }
  var outputs: CheckItemViewModelOutputs { get }
}

// MARK: - ViewModel
class CheckItemViewModel: CheckItemViewModelInputs, CheckItemViewModelOutputs, CheckItemViewModelType {

    // MARK: Inputs
    internal var tableViewItemDeletedObservable: Observable<IndexPath>
    internal var categoryItemObject: Category

    // MARK: Outputs
    public lazy var LostCheckDataBehaviorRelay = BehaviorRelay<List<CheckItem>>(value: categoryItemObject.checkItems)

    // MARK: InputOutputTypes
    public var inputs: CheckItemViewModelInputs { return self }
    public var outputs: CheckItemViewModelOutputs { return self }

    // MARK: Libraries&Propaties
    private let realm = try! Realm()
    private let disposeBag = DisposeBag()

    // MARK: - Initialize
    init(tableViewItemDeletedObservable: Observable<IndexPath>,
         categoryItemObject: Category) {
        self.tableViewItemDeletedObservable = tableViewItemDeletedObservable
        self.categoryItemObject = categoryItemObject

        LostCheckDataBehaviorRelay.accept(categoryItemObject.checkItems)
        setupNotifications()
    }

    // MARK: - Setups
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fromRegisteCheckItemViewCall(notification:)),
            name: NSNotification.Name.CheckItemViewFromRegisterViewNotification,
            object: nil)
    }

    // MARK: - Functions
    /*
     RegisterCheckItemViewControllerから呼ばれる通知
        遷移先（RegisterCheckItemViewController）で登録したCategoryItemを
        遷移元（CheckItemTableViewController）に値渡しするために、Notificationが有効だった。
        参考：https://qiita.com/star__hoshi/items/41dff8231dd2219de9bd
     */
    @objc func fromRegisteCheckItemViewCall(notification: Notification) {
        if let checkItem = notification.object as? CheckItem {
            try! realm.write {
                self.categoryItemObject.checkItems.append(checkItem)
                self.LostCheckDataBehaviorRelay.accept(categoryItemObject.checkItems)
            }
        }
    }
}
