//
//  SettingViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/31.
//


import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
    }

    // MARK: Actions

    // MARK: Setups
    private func setupNavigationbar() {
        navigationItem.title = "設定"
    }

}

