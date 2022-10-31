//
//  WebViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/31.
//

import UIKit
import WebKit
import PKHUD

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private  weak var forwardButton: UIBarButtonItem!
    private var presentUrl = ""
    private var progressView = UIProgressView(progressViewStyle: .bar)

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.uiDelegate = self
        webView.navigationDelegate = self

        HUD.show(.progress, onView: view)
        if let url = URL(string: presentUrl) {
            self.webView.load(URLRequest(url: url))
        } else {
            print("URLが取得できませんでした。")
        }
        judgeToolBarButton()
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        webView.goBack()
    }

    @IBAction func didTapForwardButton(_ sender: Any) {
        webView.goForward()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("読み込み開始")
        judgeToolBarButton()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("読み込み完了")
        HUD.hide(animated: true)
        judgeToolBarButton()
    }

    private func judgeToolBarButton() {
        if webView.canGoBack {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }

        if webView.canGoForward {
            forwardButton.isEnabled = true
        } else {
            forwardButton.isEnabled = false
        }
    }

    func configure(presentUrl: String, navigationTitle: String) {
        self.presentUrl = presentUrl
        self.navigationItem.title = navigationTitle
    }

}
