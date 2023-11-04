import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
    }

    func setupTab() {
        let firstViewController = UINavigationController(rootViewController: CategoryTableViewController())
        firstViewController.tabBarItem = UITabBarItem(title: "カテゴリー", image: UIImage(systemName: "list.dash"), tag: 0)

        let secondViewController = UINavigationController(rootViewController: CheckHistoryViewController())
        secondViewController.tabBarItem = UITabBarItem(title: "履歴", image: UIImage(systemName: "clock.arrow.circlepath"), tag: 0)

        viewControllers = [firstViewController, secondViewController]

    }
}
