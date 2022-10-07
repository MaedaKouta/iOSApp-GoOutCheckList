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
public protocol LostCheckTableViewModelInputs {
}

// MARK: - OutputsProtocol
public protocol LostCheckTableViewModelOutputs {
}

public protocol LostCheckTableViewModelType {
  var inputs: LostCheckTableViewModelInputs { get }
  var outputs: LostCheckTableViewModelOutputs { get }
}

class LostCheckViewModel: LostCheckTableViewModelInputs, LostCheckTableViewModelOutputs, LostCheckTableViewModelType {

    public var inputs: LostCheckTableViewModelInputs { return self }
    public var outputs: LostCheckTableViewModelOutputs { return self }
}
