

import UIKit
import WidgetKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 全体のNavigationBarの色をグレーにする
        UINavigationBar.appearance().tintColor = UIColor(named: "mainColor")
        UITabBar.appearance().tintColor = UIColor(named: "AccentColor")

        // 初回起動時だけ呼ばれる処理で、設定の初期値をセット
        if UserDefaults.standard.bool(forKey: "isSecondLaunch") == false {

            UserDefaults.standard.set(true, forKey: "isDisplayHistoryNumber")
            UserDefaults.standard.set(true, forKey: "isSecondLaunch")
        }

        return true
    }

    // アプリ終了
    func applicationWillTerminate(_ application: UIApplication) {
        WidgetCenter.shared.reloadAllTimelines()
    }

}

