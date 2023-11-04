import UIKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let userdefaultManager = UserdefaultsManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let window = UIWindow(windowScene: scene as! UIWindowScene)
        self.window = window
        window.makeKeyAndVisible()
        window.tintColor = UIColor.customAccentColor

        /* 初期画面をViewControllerにしたい場合 */
        //let viewController = MainTabBarController()
        //self.window?.rootViewController = viewController

        /* 初期画面をNavigationControllerにしたい場合 */
        let navigationController = UINavigationController(rootViewController: MainTabBarController())
        navigationController.isNavigationBarHidden = true

        self.window?.rootViewController = navigationController

        userdefaultManager.setIsDisplayFromWidget(isTrue: false)
    }

    // アプリスリープ
    func sceneDidEnterBackground(_ scene: UIScene) {
        WidgetCenter.shared.reloadAllTimelines()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlString = URLContexts.first?.url.absoluteString else {
            return
        }

        if urlString == "GoOutCheckList://deeplink?from=widget" {
            userdefaultManager.setIsDisplayFromWidget(isTrue: true)

            let navigationController = UINavigationController(rootViewController: MainTabBarController())
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
            self.window?.rootViewController?.tabBarController?.selectedIndex = 0

        }
    }
}

