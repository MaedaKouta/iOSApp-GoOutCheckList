//
//  SceneDelegate.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/03.
//

import UIKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // ここから
        let window = UIWindow(windowScene: scene as! UIWindowScene)
        self.window = window
        window.makeKeyAndVisible()
        window.tintColor = .black

        /* 初期画面をViewControllerにしたい場合 */
        //let viewController = MainTabBarController()
        //self.window?.rootViewController = viewController

        /* 初期画面をNavigationControllerにしたい場合 */
         let navigationController = UINavigationController(rootViewController: MainTabBarController())
         navigationController.isNavigationBarHidden = true
         self.window?.rootViewController = navigationController

    }

    // アプリスリープ
    func sceneDidEnterBackground(_ scene: UIScene) {
        WidgetCenter.shared.reloadAllTimelines()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("here")
        print(URLContexts.first?.url)
    }

}

