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

struct CategoryItem {
    var name: String
}

// MARK: - InputsProtocol
public protocol CategoryTableViewModelInputs {
    var addCategoryButtonObservable: Observable <Void> { get }
}

// MARK: - OutputsProtocol
public protocol CategoryTableViewModelOutputs {
    var categoryDataBehaviorRelay: BehaviorRelay<[String]> { get }
}

public protocol CategoryTableViewModelType {
  var inputs: CategoryTableViewModelInputs { get }
  var outputs: CategoryTableViewModelOutputs { get }
}

class CategoryTableViewModel: CategoryTableViewModelInputs, CategoryTableViewModelOutputs, CategoryTableViewModelType {

    // MARK: - Inputs
    var addCategoryButtonObservable: Observable<Void>

    // MARK: - Outputs
    lazy var categoryDataBehaviorRelay = BehaviorRelay<[String]>(value: categoryList)

    public var inputs: CategoryTableViewModelInputs { return self }
    public var outputs: CategoryTableViewModelOutputs { return self }

    var categoryList: [String] = ["初期値"]
    private let disposeBag = DisposeBag()

    init(addCategoryButtonObservable: Observable<Void>) {
        self.addCategoryButtonObservable = addCategoryButtonObservable
        categoryDataBehaviorRelay.accept(categoryList)

        setupBindings()
    }

    private func setupBindings() {

        // カテゴリ追加ボタンが押されたときの処理
        addCategoryButtonObservable.asObservable()
            .subscribe(onNext: { _ in
                self.categoryList.append(contentsOf: ["追加"])
                self.categoryDataBehaviorRelay.accept(self.categoryList)
            }).disposed(by: disposeBag)
    }

}
