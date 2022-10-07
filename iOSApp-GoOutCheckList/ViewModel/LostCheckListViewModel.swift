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
public protocol LostCheckListViewModelInputs {
}

// MARK: - OutputsProtocol
public protocol LostCheckListViewModelOutputs {
}

public protocol LostCheckListViewModelType {
  var inputs: LostCheckListViewModelInputs { get }
  var outputs: LostCheckListViewModelOutputs { get }
}

class LostCheckListViewModel: LostCheckListViewModelInputs, LostCheckListViewModelOutputs, LostCheckListViewModelType {

    public var inputs: LostCheckListViewModelInputs { return self }
    public var outputs: LostCheckListViewModelOutputs { return self }
}
