//
//  SettingViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/31.
//


import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

//    let tableViewSection = ["評価", "情報"]
//    let reviewTableViewRow = ["アプリをレビューする", "アプリをシェアする", "お問い合わせ"]
//    let infoTableViewRow = ["アプリをレビューする", "アプリをシェアする", "お問い合わせ"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "test")
        setupNavigationbar()
    }

    // MARK: Actions

    // MARK: Setups
    private func setupNavigationbar() {
        navigationItem.title = "設定"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath)

        print("adfas")
        // セルに表示する値を設定する
        cell.textLabel?.text = "aaa"
        return cell
    }

}

