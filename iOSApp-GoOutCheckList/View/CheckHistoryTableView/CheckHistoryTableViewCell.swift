//
//  CheckHistoryTableViewCell.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/27.
//

import UIKit
import RealmSwift

class CheckHistoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var dateTextLabel: UILabel!
    @IBOutlet private weak var categoryTextLabel: UILabel!
    @IBOutlet private weak var dateBackgroundView: UIView!
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var newBackGroundView: UIView!
    @IBOutlet private weak var newTextLabel: UILabel!

    private let realm = try! Realm()
    private let categoryObject = try! Realm().objects(Category.self)

    func setConfigure(dateText: String, categoryId: String, isWatched: Bool) {

        let predicate = NSPredicate(format: "id == %@", categoryId)
        let categoryObject = categoryObject.filter(predicate).first

        dateTextLabel.text = dateText
        categoryTextLabel.text = categoryObject?.name

        if categoryObject?.assetsImageName != nil {
            self.categoryImageView.image = UIImage(named: categoryObject!.assetsImageName)
        } else {
            self.categoryImageView.image = UIImage(named: "question_small")
        }

        setupLayout()
        setupNewView(isWatched: isWatched)
    }

    private func setupNewView(isWatched: Bool) {
        if isWatched == true {
            newBackGroundView.isHidden = true
            newTextLabel.isHidden = true
        } else {
            newBackGroundView.isHidden = false
            newTextLabel.isHidden = false
        }
    }

    private func setupLayout() {
        dateTextLabel.adjustsFontSizeToFitWidth = true
        categoryTextLabel.adjustsFontSizeToFitWidth = true

        dateBackgroundView.backgroundColor = UIColor.white
        dateBackgroundView.tintColor = .darkGray
        dateBackgroundView.layer.cornerRadius = 5
        dateBackgroundView.layer.shadowColor = UIColor.black.cgColor
        dateBackgroundView.layer.shadowRadius = 1
        dateBackgroundView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        dateBackgroundView.layer.shadowOpacity = 0.25

        newBackGroundView.backgroundColor = UIColor.white
        newBackGroundView.tintColor = .darkGray
        newBackGroundView.layer.cornerRadius = 5
        newBackGroundView.layer.shadowColor = UIColor.black.cgColor
        newBackGroundView.layer.shadowRadius = 1
        newBackGroundView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        newBackGroundView.layer.shadowOpacity = 0.50

        categoryImageView.layer.cornerRadius = 13
        categoryImageView.layer.masksToBounds = true
        categoryImageView.layer.borderColor = CGColor.init(red: 90/256, green: 90/256, blue: 90/256, alpha: 1.0)
        categoryImageView.layer.borderWidth = 2
    }
}
