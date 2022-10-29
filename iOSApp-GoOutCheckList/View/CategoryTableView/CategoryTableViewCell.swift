//
//  CategoryTableViewCell.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/09.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var categoryImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    func configure(image: UIImage?, name: String) {
        self.nameLabel.text = name

        if image != nil {
            self.categoryImage.image = image
        } else {
            self.categoryImage.image = UIImage(named: "question_small")
        }

        setupLayout()

    }

    private func setupLayout() {
        nameLabel.adjustsFontSizeToFitWidth = true
        self.categoryImage.layer.cornerRadius = 10
        self.categoryImage.layer.masksToBounds = true
        self.categoryImage.layer.borderColor = CGColor.init(red: 90/256, green: 90/256, blue: 90/256, alpha: 1.0)
        self.categoryImage.layer.borderWidth = 2
    }

}
