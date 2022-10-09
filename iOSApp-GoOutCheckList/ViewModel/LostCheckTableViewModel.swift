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
public protocol LostCheckTableViewModelInputs {
    var tableViewItemDeletedObservable: Observable<IndexPath> { get }
    var categoryItemObject: Category { get }
}

// MARK: Outputs
public protocol LostCheckTableViewModelOutputs {
    var LostCheckDataBehaviorRelay: BehaviorRelay<List<CheckItem>> { get }
}

// MARK: InputOutputType
public protocol LostCheckTableViewModelType {
  var inputs: LostCheckTableViewModelInputs { get }
  var outputs: LostCheckTableViewModelOutputs { get }
}

// MARK: - ViewModel
class LostCheckViewModel: LostCheckTableViewModelInputs, LostCheckTableViewModelOutputs, LostCheckTableViewModelType {

    // MARK: Inputs
    internal var tableViewItemDeletedObservable: Observable<IndexPath>
    internal var categoryItemObject: Category

    // MARK: Outputs
    public lazy var LostCheckDataBehaviorRelay = BehaviorRelay<List<CheckItem>>(value: categoryItemObject.checkItems)

    // MARK: InputOutputTypes
    public var inputs: LostCheckTableViewModelInputs { return self }
    public var outputs: LostCheckTableViewModelOutputs { return self }

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
            selector: #selector(fromRegisteCheckElementViewCall(notification:)),
            name: NSNotification.Name.LostCheckViewFromRegisterViewNotification,
            object: nil)
    }

    // MARK: - Functions
    /*
     RegisterCategoryDetailViewControllerから呼ばれる通知
        遷移先（RegisterCategoryDetailViewController）で登録したCategoryItemを
        遷移元（CategoryTableViewController）に値渡しするために、Notificationが有効だった。
        参考：https://qiita.com/star__hoshi/items/41dff8231dd2219de9bd
     */
    @objc func fromRegisteCheckElementViewCall(notification: Notification) {
        if let checkItem = notification.object as? CheckItem {
            try! realm.write {
                self.categoryItemObject.checkItems.append(checkItem)
                self.LostCheckDataBehaviorRelay.accept(categoryItemObject.checkItems)
            }
        }
    }
}
