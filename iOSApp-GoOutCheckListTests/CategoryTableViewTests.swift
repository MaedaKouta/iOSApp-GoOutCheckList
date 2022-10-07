//
//  CategoryTableViewTests.swift
//  iOSApp-GoOutCheckListTests
//
//  Created by 前田航汰 on 2022/10/07.
//

import XCTest
@testable import iOSApp_GoOutCheckList

final class CategoryTableViewTests: XCTestCase {

    let vc = CategoryTableViewController()
    func test_tableViewが表示されること() {
        XCTAssertNotNil(vc.categoryDataSource.item)
    }

}
