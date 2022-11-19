//
//  CategoryTableViewCell.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/09.
//

import UIKit
import RealmSwift

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var categoryImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var latestHistoryTimeLabel: UILabel!
    @IBOutlet private weak var checkedCountLabel: UILabel!
    @IBOutlet private weak var checkedCountProgressView: UIProgressView!

    func configure(category: Category) {

        setupLayout()

        self.nameLabel.text = category.name

        if let image = UIImage(named: category.assetsImageName) {
            self.categoryImage.image = image
        } else {
            self.categoryImage.image = UIImage(named: "question_small")
        }

        // 右上の直近でチェックした日付を取得
        let latestHistoryDate = findLatestHistory(category: category)
        // 日付の表示を今日か昨日か...で分ける
        latestHistoryTimeLabel.text = separateDateText(date: latestHistoryDate)

        // もしすでにチェックしている項目があれば「○項目チェック済み/○項目」
        // なければ存在するアイテム数の「◯項目」を表示
        let allItemCount = category.checkItems.count
        let chekedItemCount = category.checkItems.filter{$0.isDone == true}.count
        if chekedItemCount == 0 {
            checkedCountLabel.text = "\(allItemCount)項目"
            checkedCountProgressView.setProgress(0.0, animated: false)
        } else {
            let checkedRatio: Float = Float(chekedItemCount)/Float(allItemCount)
            checkedCountLabel.text = "\(chekedItemCount)項目チェック済み/\(allItemCount)項目"
            checkedCountProgressView.setProgress(checkedRatio, animated: false)
        }

    }

    private func setupLayout() {
        nameLabel.adjustsFontSizeToFitWidth = true
        self.categoryImage.layer.cornerRadius = 20
        self.categoryImage.layer.masksToBounds = true
        self.categoryImage.layer.borderColor = UIColor.customIconCircleColor?.cgColor
        self.categoryImage.layer.borderWidth = 2
    }

    private func findLatestHistory(category: Category) -> Date? {
        let checkHistoryListObject = RealmManager().realm.objects(CheckHistoryList.self)

        let predicateCategoryId = NSPredicate(format: "categoryID == %@", category.id)
        let filterCheckHistoryListObject = checkHistoryListObject.first?.checkHistoryList.filter(predicateCategoryId).first?.date

        return filterCheckHistoryListObject
    }

    private func separateDateText(date: Date?) -> String {
        guard let date = date else { return "" }

        if Calendar.current.isDateInToday(date) {
            let dateStringDetail = DateUtils.stringFromDate(date: date, format: "HH:mm")
            return dateStringDetail
        } else {
            let dateStringDetail = DateUtils.stringFromDate(date: date, format: "MM/dd")
            return dateStringDetail
        }

    }

}
