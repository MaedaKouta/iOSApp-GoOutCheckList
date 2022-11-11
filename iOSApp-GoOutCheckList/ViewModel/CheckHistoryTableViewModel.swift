//
//  CheckHistoryTableViewModel.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/27.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay
import RxRealm
import RealmSwift

// MARK: - Protocol
// MARK: Inputs
public protocol CheckHistoryViewModelInputs {
    var tableViewItemSelectedObservable: Observable<IndexPath> { get }
}

// MARK: Outputs
public protocol CheckHistoryViewModelOutputs {
    var checkHistoryDataBehaviorRelay: BehaviorRelay<List<CheckHistory>> { get }
    var tableViewItemSeletedPublishRelay: PublishRelay<IndexPath> { get }
}

// MARK: InputOutputType
public protocol CheckHistoryViewModelType {
  var inputs: CheckHistoryViewModelInputs { get }
  var outputs: CheckHistoryViewModelOutputs { get }
}

// MARK: - ViewModel
class CheckHistoryViewModel: CheckHistoryViewModelInputs, CheckHistoryViewModelOutputs, CheckHistoryViewModelType {

    // MARK: Inputs
    internal var tableViewItemSelectedObservable: Observable<IndexPath>

    // MARK: Outputs
    public var checkHistoryDataBehaviorRelay = BehaviorRelay<List<CheckHistory>>(value: List<CheckHistory>())
    public var tableViewItemSeletedPublishRelay = PublishRelay<IndexPath>()

    // MARK: InputOutputTypes
    public var inputs: CheckHistoryViewModelInputs { return self }
    public var outputs: CheckHistoryViewModelOutputs { return self }

    // MARK: Libraries&Propaties
    private let realm = try! Realm()
    private let disposeBag = DisposeBag()
    private lazy var checkHistoryListObject = realm.objects(CheckHistoryList.self).first?.checkHistoryList

    // MARK: - Initialize
    init(tableViewItemSelectedObservable: Observable<IndexPath>) {
        self.tableViewItemSelectedObservable = tableViewItemSelectedObservable

        guard let checkHistoryListObject = checkHistoryListObject else {return}
        checkHistoryDataBehaviorRelay.accept(checkHistoryListObject)
        setupBindings()
    }

    // MARK: - Setups
    private func setupBindings() {

        tableViewItemSelectedObservable.asObservable()
            .subscribe { [weak self] indexPath in
                guard let checkItems = self?.checkHistoryListObject else {
                    return
                }
                self?.checkHistoryDataBehaviorRelay.accept(checkItems)
                self?.tableViewItemSeletedPublishRelay.accept(indexPath)

            }.disposed(by: disposeBag)

    }

    // MARK: Updatas
    func updateCheckHistoryList() {
        checkHistoryListObject = try! Realm().objects(CheckHistoryList.self).first?.checkHistoryList
        print(checkHistoryListObject)
        self.checkHistoryDataBehaviorRelay
            .accept(checkHistoryListObject ?? List<CheckHistory>())
    }

}
