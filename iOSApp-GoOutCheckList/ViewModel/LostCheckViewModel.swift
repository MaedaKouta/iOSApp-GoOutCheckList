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

// MARK: - InputsProtocol
public protocol LostCheckTableViewModelInputs {
}

// MARK: - OutputsProtocol
public protocol LostCheckTableViewModelOutputs {
    var LostCheckDataBehaviorRelay: BehaviorRelay<[CheckItem]> { get }
}

public protocol LostCheckTableViewModelType {
  var inputs: LostCheckTableViewModelInputs { get }
  var outputs: LostCheckTableViewModelOutputs { get }
}

class LostCheckViewModel: LostCheckTableViewModelInputs, LostCheckTableViewModelOutputs, LostCheckTableViewModelType {

    // MARK: - Outputs
    public lazy var LostCheckDataBehaviorRelay = BehaviorRelay<[CheckItem]>(value: checkList)
    public var inputs: LostCheckTableViewModelInputs { return self }
    public var outputs: LostCheckTableViewModelOutputs { return self }

    var checkList: [CheckItem] = [.init(name: "初期値", isDone: false)]
    private let disposeBag = DisposeBag()

    init() {
        LostCheckDataBehaviorRelay.accept(checkList)
        setupBindings()
    }

    private func setupBindings() {
        // Notificationの連携
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fromRegisteCheckElementViewCall(notification:)),
            name: NSNotification.Name.LostCheckViewFromRegisterViewNotification,
            object: nil)
    }

    /*
     RegisterCategoryDetailViewControllerから呼ばれる通知
        遷移先（RegisterCategoryDetailViewController）で登録したCategoryItemを
        遷移元（CategoryTableViewController）に値渡しするために、Notificationが有効だった。
        参考：https://qiita.com/star__hoshi/items/41dff8231dd2219de9bd
     */
    @objc func fromRegisteCheckElementViewCall(notification: Notification) {
        if let checkItem = notification.object as? CheckItem {
            self.checkList.append(contentsOf: [checkItem])
            self.LostCheckDataBehaviorRelay.accept(self.checkList)
        }
    }
}
