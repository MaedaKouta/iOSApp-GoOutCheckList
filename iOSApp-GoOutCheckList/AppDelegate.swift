

import UIKit
import WidgetKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 全体のNavigationBarの色をグレーにする
        UINavigationBar.appearance().tintColor = UIColor.customMainColor

        UITabBar.appearance().tintColor = UIColor.customAccentColor
        UIView.appearance().tintColor = UIColor.label

        // 初回起動時だけ呼ばれる処理で、設定の初期値をセット
        if UserDefaults.standard.bool(forKey: "isSecondLaunch") == false {
            UserDefaults.standard.set(true, forKey: "isDisplayHistoryNumber")
            UserDefaults.standard.set(true, forKey: "isSecondLaunch")

            let realm = RealmManager().realm
            let categoryListObjext = realm.objects(CategoryList.self).first?.list

            // 初回起動時に保存しておく１つ目のチェックアイテムとカテゴリ
            let firstCategoryCheckItem1_1 = CheckItem()
            let firstCategoryCheckItem1_2 = CheckItem()
            let firstCategoryCheckItem1_3 = CheckItem()
            let firstCategoryCheckItem1_4 = CheckItem()
            let firstCategoryCheckItem1_5 = CheckItem()
            firstCategoryCheckItem1_1.name = "携帯"
            firstCategoryCheckItem1_2.name = "ワイヤレスイヤホン"
            firstCategoryCheckItem1_3.name = "家の鍵"
            firstCategoryCheckItem1_4.name = "財布"
            firstCategoryCheckItem1_5.name = "メガネ"

            let firstCategory1 = Category()
            firstCategory1.name = "常に持ち歩くもの"
            firstCategory1.assetsImageName = "bag_small"
            firstCategory1.checkItems.append(firstCategoryCheckItem1_1)
            firstCategory1.checkItems.append(firstCategoryCheckItem1_2)
            firstCategory1.checkItems.append(firstCategoryCheckItem1_3)
            firstCategory1.checkItems.append(firstCategoryCheckItem1_4)
            firstCategory1.checkItems.append(firstCategoryCheckItem1_5)

            // 初回起動時に保存しておく２つ目のチェックアイテムとカテゴリ
            let firstCategoryCheckItem2_1 = CheckItem()
            let firstCategoryCheckItem2_2 = CheckItem()
            let firstCategoryCheckItem2_3 = CheckItem()
            let firstCategoryCheckItem2_4 = CheckItem()
            firstCategoryCheckItem2_1.name = "保険証"
            firstCategoryCheckItem2_2.name = "お薬手帳"
            firstCategoryCheckItem2_3.name = "診察券"
            firstCategoryCheckItem2_4.name = "現金"

            let firstCategory2 = Category()
            firstCategory2.name = "病院"
            firstCategory2.assetsImageName = "building_small"
            firstCategory2.checkItems.append(firstCategoryCheckItem2_1)
            firstCategory2.checkItems.append(firstCategoryCheckItem2_2)
            firstCategory2.checkItems.append(firstCategoryCheckItem2_3)
            firstCategory2.checkItems.append(firstCategoryCheckItem2_4)

            // 初回起動時に保存しておく３つ目のチェックアイテムとカテゴリ
            let firstCategoryCheckItem3_1 = CheckItem()
            let firstCategoryCheckItem3_2 = CheckItem()
            let firstCategoryCheckItem3_3 = CheckItem()
            let firstCategoryCheckItem3_4 = CheckItem()
            let firstCategoryCheckItem3_5 = CheckItem()
            let firstCategoryCheckItem3_6 = CheckItem()
            let firstCategoryCheckItem3_7 = CheckItem()
            firstCategoryCheckItem3_1.name = "社員証"
            firstCategoryCheckItem3_2.name = "AppleWatch"
            firstCategoryCheckItem3_3.name = "財布"
            firstCategoryCheckItem3_4.name = "パソコン"
            firstCategoryCheckItem3_5.name = "メモ帳"
            firstCategoryCheckItem3_6.name = "携帯"
            firstCategoryCheckItem3_7.name = "モバイル充電器"

            let firstCategory3 = Category()
            firstCategory3.name = "仕事"
            firstCategory3.assetsImageName = "meeting_small"
            firstCategory3.checkItems.append(firstCategoryCheckItem3_1)
            firstCategory3.checkItems.append(firstCategoryCheckItem3_2)
            firstCategory3.checkItems.append(firstCategoryCheckItem3_3)
            firstCategory3.checkItems.append(firstCategoryCheckItem3_4)
            firstCategory3.checkItems.append(firstCategoryCheckItem3_5)
            firstCategory3.checkItems.append(firstCategoryCheckItem3_6)
            firstCategory3.checkItems.append(firstCategoryCheckItem3_7)

            // RealmのcategoryListObjextが空だった場合に追加もさせる
            try! realm.write() {
                if categoryListObjext == nil {
                    let categoryList = CategoryList()
                    categoryList.list.append(firstCategory1)
                    categoryList.list.append(firstCategory2)
                    categoryList.list.append(firstCategory3)
                    realm.add(categoryList)
                } else {
                    categoryListObjext?.append(firstCategory1)
                    categoryListObjext?.append(firstCategory2)
                    categoryListObjext?.append(firstCategory3)
                }
            }
        }

        print(RealmManager().realm.objects(Category.self))
        print(RealmManager().realm.objects(CategoryList.self))
        print(RealmManager().realm.objects(CheckItem.self))
        print(RealmManager().realm.objects(CheckHistory.self))

        return true
    }

    // アプリ終了
    func applicationWillTerminate(_ application: UIApplication) {
        WidgetCenter.shared.reloadAllTimelines()
    }

}

