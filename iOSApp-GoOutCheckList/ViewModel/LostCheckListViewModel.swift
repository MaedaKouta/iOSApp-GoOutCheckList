//
//  LostCheckListViewModel.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/07.
//

import Foundation
import Foundation
import RxCocoa
import RxSwift
import RxRelay

// MARK: - InputsProtocol
public protocol LostCheckListTableViewModelInputs {
}

// MARK: - OutputsProtocol
public protocol LostCheckListTableViewModelOutputs {
}

public protocol LostCheckListTableViewModelType {
  var inputs: LostCheckListTableViewModelInputs { get }
  var outputs: LostCheckListTableViewModelOutputs { get }
}

class LostCheckListViewModel: LostCheckListTableViewModelInputs, LostCheckListTableViewModelOutputs, LostCheckListTableViewModelType {

    public var inputs: LostCheckListTableViewModelInputs { return self }
    public var outputs: LostCheckListTableViewModelOutputs { return self }
}
