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

// MARK: - InputsProtocol
public protocol CategoryTableViewModelInputs {
}

// MARK: - OutputsProtocol
public protocol CategoryTableViewModelOutputs {
    var categoryDataBehaviorRelay: BehaviorRelay<[CategoryItem]> { get }
}

public protocol CategoryTableViewModelType {
  var inputs: CategoryTableViewModelInputs { get }
  var outputs: CategoryTableViewModelOutputs { get }
}

class CategoryTableViewModel: CategoryTableViewModelInputs, CategoryTableViewModelOutputs, CategoryTableViewModelType {

    // MARK: - Inputs


    // MARK: - Outputs
    public lazy var categoryDataBehaviorRelay = BehaviorRelay<[CategoryItem]>(value: categoryList)

    public var inputs: CategoryTableViewModelInputs { return self }
    public var outputs: CategoryTableViewModelOutputs { return self }

    var categoryList: [CategoryItem] = [CategoryItem()]
    private let disposeBag = DisposeBag()

    init() {
        categoryDataBehaviorRelay.accept(categoryList)

        setupBindings()
    }

    private func setupBindings() {
        // Notificationの連携
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fromRegisteCategoryViewCall(notification:)),
            name: NSNotification.Name.CategoryViewFromRegisterViewNotification,
            object: nil)
    }

    /*
     RegisterCategoryDetailViewControllerから呼ばれる通知
        遷移先（RegisterCategoryDetailViewController）で登録したCategoryItemを
        遷移元（CategoryTableViewController）に値渡しするために、Notificationが有効だった。
        参考：https://qiita.com/star__hoshi/items/41dff8231dd2219de9bd
     */
    @objc func fromRegisteCategoryViewCall(notification: Notification) {
        if let categoryItem = notification.object as? CategoryItem {
            self.categoryList.append(contentsOf: [categoryItem])
            self.categoryDataBehaviorRelay.accept(self.categoryList)
        }
    }

}
