//
//  CheckHistoryTableViewCell.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/27.
//

import UIKit

class CheckHistoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var dateTextLabel: UILabel!
    @IBOutlet private weak var categoryTextLabel: UILabel!
    @IBOutlet private weak var dateBackgroundView: UIView!
    @IBOutlet private weak var categoryImageView: UIImageView!

    func setConfigure(dateText: String, categoryText: String, categoryImage: UIImage?) {
        dateTextLabel.text = dateText
        categoryTextLabel.text = categoryText

        if categoryImage != nil {
            self.categoryImageView.image = categoryImage
        } else {
            self.categoryImageView.image = UIImage(named: "question_small")
        }

        setupLayout()
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

        categoryImageView.layer.cornerRadius = 10
        categoryImageView.layer.masksToBounds = true
        categoryImageView.layer.borderColor = CGColor.init(red: 90/256, green: 90/256, blue: 90/256, alpha: 1.0)
        categoryImageView.layer.borderWidth = 2
    }
}
