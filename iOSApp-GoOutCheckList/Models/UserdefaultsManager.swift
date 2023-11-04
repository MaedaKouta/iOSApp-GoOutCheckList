import Foundation

// Realmの保存先をWidgetと同じ保存先にする
public class UserdefaultsManager {
    let userdefault = UserDefaults(suiteName: "group.org.tetoblog.iOSApp-GoOutCheckList.userdefault")

    enum Key: String {
        case conversionCount
        case lastReviewRequestDate
        case didReviewed
        case shouldShowReview // これでアイテムチェック画面から前画面に値渡している。こういう値の渡し方絶対だめだから要修正
    }

    func set<T>(_ value: T, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    func getInteger(forKey key: Key) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }

    func getDate(forKey key: Key) -> Date? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? Date
    }

    func getBool(forKey key: Key) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }

    func setBool(_ value: Bool, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    func reset(forKey key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    // MARK: 下記のuserDefaultsNameは上記に合わせていこう
    // isDisplayHistoryNumber
    func setIsDisplayHistoryNumber(isDisplay: Bool) {
        userdefault!.set(isDisplay, forKey: "isDisplayHistoryNumber")
    }

    func getIsDisplayHistoryNumber() -> Bool {
        return userdefault!.bool(forKey: "isDisplayHistoryNumber")
    }

    // widgetCategoryId
    func setWidgetCategoryId(id: String) {
        userdefault!.set(id, forKey: "widgetCategoryId")
    }

    func getWidgetCategoryId() -> String {
        return userdefault!.string(forKey: "widgetCategoryId") ?? ""
    }

    // isFromWidget
    func setIsDisplayFromWidget(isTrue: Bool) {
        userdefault!.set(isTrue, forKey: "isDisplayFromWidget")
    }

    func getIsDisplayFromWidget() -> Bool {
        return userdefault!.bool(forKey: "isDisplayFromWidget")
    }

    // isSecondLaunch
    func setIsSecondLaunch(isTrue: Bool) {
        userdefault!.set(isTrue, forKey: "isSecondLaunch")
    }

    func getIsSecondLaunch() -> Bool {
        return userdefault!.bool(forKey: "isSecondLaunch")
    }

    
}
