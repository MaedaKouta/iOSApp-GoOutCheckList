//
//  SettingViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/31.
//


import UIKit

//struct SettingItem {
//    let title: String
//    let nextViewLink: String?
//    let subTitle: String?
//}

class SettingViewController: UIViewController {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }

//    let tableViewSectionTitle = ["評価", "情報"]
//    let reviewTableViewRow: [SettingItem] = [
//        SettingItem(title: "お問い合わせ", nextViewLink: "http://dfsfsd", subTitle: nil)
//    ]
//    let infoTableViewRow: [SettingItem] = [
//        SettingItem(title: "プライバシーポリシー", nextViewLink: "http://dfsfsd", subTitle: nil),
//        SettingItem(title: "利用規約", nextViewLink: "http://dfsfsd", subTitle: nil),
//        SettingItem(title: "", nextViewLink: "http://dfsfsd", subTitle: nil)
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "test")
        setupNavigationbar()
    }

    // MARK: Actions

    // MARK: Setups
    private func setupNavigationbar() {
        navigationItem.title = "設定"
    }

}

