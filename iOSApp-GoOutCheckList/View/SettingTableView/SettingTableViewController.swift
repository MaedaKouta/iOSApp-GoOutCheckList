//
//  SettingViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/31.
//


import UIKit
import SwiftUI

class SettingTableViewController: UITableViewController {

    @IBOutlet private weak var versionLabel: UILabel!

    private let reviewUrl = ""
    private let feedbackUrl = "https://forms.gle/dkDVq2x3QpDEYmPm6"
    private let privacyUrl = "https://tetoblog.org/base-conversion/privacy/"
    private let ruleUrl = "https://tetoblog.org/base-conversion/rule/"
    private let twitterUrl = "https://twitter.com/kota_org"

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
            prepareWebView(url: feedbackUrl, title: "フィードバックを送る")


        } else if indexPath == [1, 0] {
            // プライバシーポリシー
            prepareWebView(url: privacyUrl, title: "プライバシー")

        } else if indexPath == [1, 1] {
            // 利用規約
            prepareWebView(url: ruleUrl, title: "利用規約")

        } else if indexPath == [1, 2] {
            // ライセンス
            guard #available(iOS 13.0.0, *) else { return }
            let vc = UIHostingController(rootView: LisenceSwiftUIView())
            vc.navigationItem.title = "ライセンス"
            self.navigationController?.pushViewController(vc, animated: true)

        } else if indexPath == [1, 3] {
            // バージョン

        } else if indexPath == [2, 0] {
            // 開発者のTwitter
            openSafari(urlString: twitterUrl)

        } else if indexPath == [3, 0] {
            // データの初期化

        }

        tableView.deselectRow(at: indexPath, animated: true)

    }

    // MARK: Setups
    private func setupNavigationbar() {
        navigationItem.title = "設定"
    }

    private func openSafari(urlString: String) {
        let url = NSURL(string: urlString)
        // 外部ブラウザ（Safari）で開く
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }

    private func openTwitter() {
        //guard let twitterUrl = URL(string: "twitter://") else { return }
        //UIApplication.shared.openURL(twitterUrl)
    }

    private func prepareWebView(url: String, title: String) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webVC.configure(presentUrl: url, navigationTitle: title)
        self.navigationController?.pushViewController(webVC, animated: true)
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

