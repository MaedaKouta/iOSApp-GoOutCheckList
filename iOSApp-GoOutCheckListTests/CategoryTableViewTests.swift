//
//  CategoryTableViewTests.swift
//  iOSApp-GoOutCheckListTests
//
//  Created by 前田航汰 on 2022/10/07.
//

import XCTest
import RealmSwift
@testable import iOSApp_GoOutCheckList

final class CategoryTableViewTests: XCTestCase {

    private var vc: CategoryTableViewController!
    private var categoryDataSource: CategoryDataSource!
    private var tableView: UITableView!

    override func setUp() {
        vc = CategoryTableViewController()
        vc.loadView()
        categoryDataSource = vc.checkCategoryDataSource()
        tableView = vc.tableView
    }

    func test_tableViewが表示されること() {
        XCTAssertTrue(vc.view.subviews.contains(tableView))
    }

    func test_unknownImageが自動で入っていること() {
        let category = Category()
        category.name = "テスト"
        categoryDataSource.item.append(category)
        XCTAssertNotNil(categoryDataSource.item.last?.imageData)
    }

}
