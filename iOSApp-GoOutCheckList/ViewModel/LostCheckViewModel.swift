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
    var LostCheckDataBehaviorRelay: BehaviorRelay<[String]> { get }
}

public protocol LostCheckTableViewModelType {
  var inputs: LostCheckTableViewModelInputs { get }
  var outputs: LostCheckTableViewModelOutputs { get }
}

class LostCheckViewModel: LostCheckTableViewModelInputs, LostCheckTableViewModelOutputs, LostCheckTableViewModelType {

    // MARK: - Outputs
    public lazy var LostCheckDataBehaviorRelay = BehaviorRelay<[String]>(value: checkList)
    public var inputs: LostCheckTableViewModelInputs { return self }
    public var outputs: LostCheckTableViewModelOutputs { return self }

    var checkList: [String] = ["初期値"]
    private let disposeBag = DisposeBag()

    init() {
        LostCheckDataBehaviorRelay.accept(checkList)
    }
}
