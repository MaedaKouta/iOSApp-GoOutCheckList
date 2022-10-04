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

// MARK: - Outputs
protocol CategoryTableViewModelOutputs {
    var resultLabelPublishRelay: BehaviorRelay<String> { get }
}

class CategoryTableViewModel {

    lazy var dataObservable = BehaviorRelay<[String]>(value: categoryList)
    var categoryList: [String] = ["初期値"]
    private let disposeBag = DisposeBag()

    init() {
        dataObservable.accept(categoryList)
    }

}
