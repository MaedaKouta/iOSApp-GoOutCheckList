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
            self.categoryImage.image = UIImage(named: "unknownImage")
        }

    }

}
