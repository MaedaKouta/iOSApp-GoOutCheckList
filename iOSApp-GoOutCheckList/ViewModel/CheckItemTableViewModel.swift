//
// LostCheckListViewModel.swift
// iOSApp-GoOutCheckList
//
// Created by 前田航汰 on 2022/10/07.
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
    var tableViewItemSeletedObservable: Observable<IndexPath> { get }
    var categoryObject: Category { get }
}

// MARK: Outputs
public protocol CheckItemViewModelOutputs {
    var CheckItemDataBehaviorRelay: BehaviorRelay<List<CheckItem>> { get }
    var tableViewItemSeletedPublishRelay: PublishRelay<IndexPath> { get }
    var allItemSelectedPublishSubject: PublishRelay<Void> { get }
    var addItemPublishRelay: PublishRelay<Void> { get }
}

// MARK: InputOutputType
public protocol CheckItemViewModelType {
    var inputs: CheckItemViewModelInputs { get }
    var outputs: CheckItemViewModelOutputs { get }
}

// MARK: - ViewModel
class CheckItemViewModel: CheckItemViewModelInputs, CheckItemViewModelOutputs, CheckItemViewModelType {

    // MARK: Inputs
    internal var tableViewItemSeletedObservable: Observable<IndexPath>
    internal var categoryObject: Category

    // MARK: Outputs
    public lazy var CheckItemDataBehaviorRelay = BehaviorRelay<List<CheckItem>>(value: categoryObject.checkItems)
    public var tableViewItemSeletedPublishRelay = PublishRelay<IndexPath>()
    public var allItemSelectedPublishSubject = PublishRelay<Void>()
    public var addItemPublishRelay = PublishRelay<Void>()

    // MARK: InputOutputTypes
    public var inputs: CheckItemViewModelInputs { return self }
    public var outputs: CheckItemViewModelOutputs { return self }

    // MARK: Libraries&Propaties
    private let realm = try! Realm()
    private let disposeBag = DisposeBag()

    // MARK: - Initialize
    init(tableViewItemSeletedObservable: Observable<IndexPath>,
         categoryObject: Category) {
        self.tableViewItemSeletedObservable = tableViewItemSeletedObservable
        self.categoryObject = categoryObject
        CheckItemDataBehaviorRelay.accept(categoryObject.checkItems)
        setupBindings()
        setupNotifications()
    }

    // MARK: Setter
    func setDeletedItem() {
        let checkItems = categoryObject.checkItems
        CheckItemDataBehaviorRelay.accept(checkItems)

        // 値が空なら何もしない
        if checkItems.isEmpty {
            return
        }

        if checkItems.allSatisfy({$0.isDone == true}) {
            self.allItemSelectedPublishSubject.accept(())
        }

    }

    // MARK: - Setups
    private func setupBindings() {
        tableViewItemSeletedObservable.asObservable()
            .subscribe { [weak self] indexPath in
                try! self?.realm.write {
                    self?.categoryObject.checkItems[indexPath.row].isDone.toggle()
                }
                guard let checkItems = self?.categoryObject.checkItems else {
                    return
                }
                self?.CheckItemDataBehaviorRelay.accept(checkItems)
                self?.tableViewItemSeletedPublishRelay.accept(indexPath)
                if checkItems.allSatisfy({$0.isDone == true}) {
                    self?.allItemSelectedPublishSubject.accept(())
                }
            }.disposed(by: disposeBag)
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fromRegisteCheckItemViewCall(notification:)),
            name: NSNotification.Name.CheckItemViewFromRegisterViewNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fromEditViewCall(notification:)),
            name: NSNotification.Name.CheckItemViewFromEditOverwriteNotification,
            object: nil)
    }

    // MARK: - Functions
    /*
     RegisterCheckItemViewControllerから呼ばれる通知
     遷移先（RegisterCheckItemViewController）で登録したCategoryItemを
     遷移元（CheckItemTableViewController）に値渡しするために、Notificationが有効だった。
     参考：https://qiita.com/star__hoshi/items/41dff8231dd2219de9bd
     */
    @objc private func fromRegisteCheckItemViewCall(notification: Notification) {
        if let checkItem = notification.object as? CheckItem {
            try! realm.write {
                self.categoryObject.checkItems.append(checkItem)
                self.CheckItemDataBehaviorRelay.accept(categoryObject.checkItems)
            }
            addItemPublishRelay.accept(())
        }
    }

    @objc private func fromEditViewCall(notification: Notification) {
        guard let index = notification.userInfo!["index"] as? Int, let itemName = notification.userInfo!["itemName"] as? String else {
            return
        }

        try! realm.write {
            self.categoryObject.checkItems[index].name = itemName
            self.CheckItemDataBehaviorRelay.accept(categoryObject.checkItems)
        }
        addItemPublishRelay.accept(())
    }

}
