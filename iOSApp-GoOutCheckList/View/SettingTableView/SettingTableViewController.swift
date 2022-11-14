//
//  SettingViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/31.
//


import UIKit
import SwiftUI
import RealmSwift
import PKHUD
import WidgetKit

class SettingTableViewController: UITableViewController {

    @IBOutlet private weak var versionLabel: UILabel!
    @IBOutlet private weak var isDisplayHistoryNumberSwitch: UISwitch!
    @IBOutlet private weak var widgetCategoryButton: UIButton!

    private var widgetCategoryPullDownItems = UIMenu(options: .displayInline, children: [])

    private let reviewUrl = ""
    private let feedbackUrl = "https://forms.gle/3T3eNwuggnUvUd9t5"
    private let privacyUrl = "https://local-tumbleweed-7ea.notion.site/407c8f689ad24676ae4fecb76abe39d9"
    private let ruleUrl = "https://local-tumbleweed-7ea.notion.site/570ea223dce3463b9b42a3528b516603"
    private let twitterUrl = "https://twitter.com/kota_org"

    private var realm = RealmManager().realm
    let categoyListObject =  RealmManager().realm.objects(CategoryList.self)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        // NavigationBarの背景色の設定
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        isDisplayHistoryNumberSwitch.setOn(UserDefaults.standard.bool(forKey: "isDisplayHistoryNumber"), animated: false)

        versionLabel.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String

        setupWidgetCategoryButton()
        setupWidgetCategoryPullDownItems()
    }

    @IBAction func isChangedDisplayHistoryNumberSwitch(_ sender: Any) {
        UserDefaults.standard.set(isDisplayHistoryNumberSwitch.isOn, forKey: "isDisplayHistoryNumber")
    }

    // MARK: Actions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         if indexPath == [0, 0] {
            // 履歴の通知表示

        } else if indexPath == [0, 1] {
            // 履歴の一括削除
            deleteHistoryDataAlert()

        } else if indexPath == [1, 0] {
            // ウィジェット表示カテゴリ

        } else if indexPath == [2, 0] {
            // アプリを評価する
            shareApp()

        } else if indexPath == [2, 1] {
            // アプリをシェアする
            shareApp()

        } else if indexPath == [2, 2] {
            // フィードバックを送る
            prepareWebView(url: feedbackUrl, title: "フィードバックを送る")

        } else if indexPath == [3, 0] {
            // プライバシーポリシー
            prepareWebView(url: privacyUrl, title: "プライバシーポリシー")

        } else if indexPath == [3, 1] {
            // 利用規約
            prepareWebView(url: ruleUrl, title: "利用規約")

        } else if indexPath == [3, 2] {
            // ライセンス
            let vc = UIHostingController(rootView: LisenceSwiftUIView())
            vc.navigationItem.title = "ライセンス"
            self.navigationController?.pushViewController(vc, animated: true)

        } else if indexPath == [3, 3] {
            // 開発者のTwitter
            openSafari(urlString: twitterUrl)

        } else if indexPath == [3, 4] {
            // バージョン


        } else if indexPath == [4, 0] {
            // データの初期化
            deleteDataAlert()
        }

        tableView.deselectRow(at: indexPath, animated: true)

    }

    // MARK: Setups
    private func setupNavigationbar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "設定"
    }

    // Buttonを左右反転させる
    private func setupWidgetCategoryButton() {
        widgetCategoryButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        widgetCategoryButton.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
        widgetCategoryButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }

    private func setupWidgetCategoryPullDownItems() {
        guard let categoryObjects = categoyListObject.first?.list else {
            self.widgetCategoryButton.setTitle("カテゴリー無し", for: .normal)
            return
        }
        if categoryObjects.count == 0 {
            self.widgetCategoryButton.setTitle("カテゴリー無し", for: .normal)
            return
        }

        let widgetCategoryIndex = findWidgetCategoryIdIndex()
        self.widgetCategoryButton.setTitle(categoryObjects.elements[widgetCategoryIndex].name, for: .normal)

        updateWidgetCategoryPullDownItems()
    }

    private func openSafari(urlString: String) {
        let url = NSURL(string: urlString)
        // 外部ブラウザ（Safari）で開く
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }

    private func prepareWebView(url: String, title: String) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webVC.configure(presentUrl: url, navigationTitle: title)
        self.navigationController?.pushViewController(webVC, animated: true)
    }

    private func shareApp() {
        let shareText = """
        「外出チェッカー」

        外出の際、忘れ物に不安ではですか？
        病院・仕事・趣味などなど
        用途に合わせた持ち物を登録しておくことで、
        忘れ物を防止できます。
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

    // Widgets
    private func updateWidgetCategoryPullDownItems() {
        guard let categoryObjects = categoyListObject.first?.list else {
            self.widgetCategoryButton.setTitle("カテゴリー無し", for: .normal)
            return
        }
        if categoryObjects.count == 0 {
            self.widgetCategoryButton.setTitle("カテゴリー無し", for: .normal)
            return
        }

        var pullDowunChildren: [UIAction] = []
        let widgetCategoryIndex = findWidgetCategoryIdIndex()

        for i in 0..<categoryObjects.elements.count {

            if i == widgetCategoryIndex {
                pullDowunChildren.append(UIAction(title: categoryObjects.elements[i].name, image: UIImage(systemName: "checkmark"), handler: { [weak self] _ in
                    print("\(categoryObjects.elements[i].name)が押されました")
                    UserDefaults.standard.set(categoryObjects.elements[i].id, forKey: "widgetCategoryId")
                    self?.widgetCategoryButton.setTitle(categoryObjects.elements[i].name, for: .normal)
                    self?.updateWidgetCategoryPullDownItems()
                    WidgetCenter.shared.reloadAllTimelines()
                }))
            } else {
                pullDowunChildren.append(UIAction(title: categoryObjects.elements[i].name, handler: { [weak self] _ in

                    print("\(categoryObjects.elements[i].name)が押されました")
                    UserDefaults.standard.set(categoryObjects.elements[i].id, forKey: "widgetCategoryId")
                    self?.widgetCategoryButton.setTitle(categoryObjects.elements[i].name, for: .normal)
                    self?.updateWidgetCategoryPullDownItems()
                    WidgetCenter.shared.reloadAllTimelines()
                }))
            }
        }

        widgetCategoryPullDownItems = UIMenu(options: .displayInline, children: pullDowunChildren)

        widgetCategoryButton.menu = widgetCategoryPullDownItems
        widgetCategoryButton.showsMenuAsPrimaryAction = true

    }

    // MARK: Alerts
    private func findWidgetCategoryIdIndex() -> Int {
        guard let categoryObjects = categoyListObject.first?.list else {
            return 0
        }
        if categoryObjects.count == 0 {
            return 0
        }

        var widgetCategoryIndex = 0
        for i in 0..<categoryObjects.elements.count {
            if categoryObjects.elements[i].id == UserDefaults.standard.string(forKey: "widgetCategoryId") {
                widgetCategoryIndex = i
            }
        }

        return widgetCategoryIndex

    }

    private func deleteHistoryDataAlert() {
        let alert: UIAlertController = UIAlertController(
            title: "履歴の削除",
            message: """
            履歴を完全に削除してよろしいですか？
            この操作は取り消せません。
            """,
            preferredStyle:  UIAlertController.Style.alert
        )

        let deleteAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.destructive, handler:{ [weak self]
                (action: UIAlertAction!) -> Void in

            let checkHistoryListObject = self?.realm.objects(CheckHistoryList.self)
            let checkHistoryObject = self?.realm.objects(CheckHistory.self)

            try! self?.realm.write {
                if let checkHistoryListObject = checkHistoryListObject,
                   checkHistoryListObject.count != 0  {
                    self?.realm.delete(checkHistoryListObject)
                }

                if let checkHistoryObject = checkHistoryObject,
                   checkHistoryObject.count != 0 {
                    self?.realm.delete(checkHistoryObject)
                }
            }

            HUD.flash(.progress, delay: 0.2) { _ in
                HUD.flash(.labeledSuccess(title: "削除完了", subtitle: nil), delay: 0.4)
            }

        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }

    private func deleteDataAlert() {
        let alert: UIAlertController = UIAlertController(
            title: "データの初期化",
            message: """
            データを完全に削除してよろしいですか？
            この操作は取り消せません。
            """,
            preferredStyle:  UIAlertController.Style.alert
        )

        let deleteAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.destructive, handler:{ [weak self]
                (action: UIAlertAction!) -> Void in

            let categoryObject = self?.realm.objects(Category.self)
            let checkItemObject = self?.realm.objects(CheckItem.self)
            let checkHistoryObject = self?.realm.objects(CheckHistory.self)

            try! self?.realm.write {
                if let categoryObject = categoryObject,
                   categoryObject.count != 0 {
                    self?.realm.delete(categoryObject)
                }

                if let checkItemObject = checkItemObject,
                   checkItemObject.count != 0 {
                    self?.realm.delete(checkItemObject)
                }

                if let checkHistoryObject = checkHistoryObject,
                   checkHistoryObject.count != 0 {
                    self?.realm.delete(checkHistoryObject)
                }
            }

            HUD.flash(.progress, delay: 0.4) { _ in
                HUD.flash(.labeledSuccess(title: "削除完了", subtitle: nil), delay: 0.6) { _ in
                    self?.navigationController?.popViewController(animated: true)
                }
            }

        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
        })
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    private func noneCategoryAlert() {
        let alert: UIAlertController = UIAlertController(
            title: "",
            message: """
            カテゴリーが何もありません。
            """,
            preferredStyle:  UIAlertController.Style.alert
        )

        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

}

