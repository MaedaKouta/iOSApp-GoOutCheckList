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

// MARK: - InputsProtocol
public protocol LostCheckTableViewModelInputs {
    var tableViewItemDeletedObservable: Observable<IndexPath> { get }
    var categoryItemObject: CategoryItem { get }
}

// MARK: - OutputsProtocol
public protocol LostCheckTableViewModelOutputs {
    var LostCheckDataBehaviorRelay: BehaviorRelay<List<CheckItem>> { get }
}

public protocol LostCheckTableViewModelType {
  var inputs: LostCheckTableViewModelInputs { get }
  var outputs: LostCheckTableViewModelOutputs { get }
}

class LostCheckViewModel: LostCheckTableViewModelInputs, LostCheckTableViewModelOutputs, LostCheckTableViewModelType {

    // MARK: - Inputs
    internal var tableViewItemDeletedObservable: Observable<IndexPath>
    internal var categoryItemObject: CategoryItem

    // MARK: - Outputs
    public lazy var LostCheckDataBehaviorRelay = BehaviorRelay<List<CheckItem>>(value: categoryItemObject.checkItems)

    public var inputs: LostCheckTableViewModelInputs { return self }
    public var outputs: LostCheckTableViewModelOutputs { return self }

    private let realm = try! Realm()
    private let disposeBag = DisposeBag()

    init(tableViewItemDeletedObservable: Observable<IndexPath>,
         categoryItemObject: CategoryItem) {
        self.tableViewItemDeletedObservable = tableViewItemDeletedObservable
        self.categoryItemObject = categoryItemObject

        LostCheckDataBehaviorRelay.accept(categoryItemObject.checkItems)
        setupBindings()
        setupNotifications()
    }

    private func setupBindings() {
        tableViewItemDeletedObservable.asObservable()
            .subscribe(onNext: { indexPath in
            }).disposed(by: disposeBag)
    }

    // MARK: Notification
    /*
     RegisterCategoryDetailViewControllerから呼ばれる通知
        遷移先（RegisterCategoryDetailViewController）で登録したCategoryItemを
        遷移元（CategoryTableViewController）に値渡しするために、Notificationが有効だった。
        参考：https://qiita.com/star__hoshi/items/41dff8231dd2219de9bd
     */
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fromRegisteCheckElementViewCall(notification:)),
            name: NSNotification.Name.LostCheckViewFromRegisterViewNotification,
            object: nil)
    }

    @objc func fromRegisteCheckElementViewCall(notification: Notification) {
        if let checkItem = notification.object as? CheckItem {
            try! realm.write {
                self.categoryItemObject.checkItems.append(checkItem)
                self.LostCheckDataBehaviorRelay.accept(categoryItemObject.checkItems)
            }
        }
    }
}
