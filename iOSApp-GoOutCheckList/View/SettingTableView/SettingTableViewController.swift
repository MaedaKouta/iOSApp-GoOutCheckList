//
//  SettingViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/31.
//


import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet private weak var versionLabel: UILabel!

    private let reviewUrl = "https://apps.apple.com/jp/app/%E9%80%B2%E6%95%B0%E3%83%9E%E3%82%B9%E3%82%BF%E3%83%BC/id1581706168?mt=8&action=write-review"
    private let feedbackUrl = "https://forms.gle/dkDVq2x3QpDEYmPm6"
    private let privacyUrl = "https://tetoblog.org/base-conversion/privacy/"
    private let ruleUrl = "https://tetoblog.org/base-conversion/rule/"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()

        versionLabel.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    // MARK: Actions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [0, 0] {
            // アプリをシェアする
            shareApp()
        } else if indexPath == [0, 1] {
            // フィードバックを送る
        } else if indexPath == [1, 0] {
            // プライバシーポリシー
        } else if indexPath == [1, 1] {
            // 利用規約
        } else if indexPath == [1, 2] {
            // ライセンス
        } else if indexPath == [2, 1] {
            // 開発者のアプリ
        } else if indexPath == [2, 2] {
            // 開発者のTwitter
        } else if indexPath == [3, 0] {
            // データの初期化
        }

        tableView.deselectRow(at: indexPath, animated: true)

    }

    // MARK: Setups
    private func setupNavigationbar() {
        navigationItem.title = "設定"
    }

    private func shareApp() {
        // TODO: 文字を考える
        let shareText = """
        サブタイトル
        「タイトル」

        本文本文本文本文
        """

        let activityItems = [shareText] as [Any]

        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        // iPadでクラッシュするため、iPadのみレイアウトの変更
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        self.present(activityVC, animated: true)
    }

}

