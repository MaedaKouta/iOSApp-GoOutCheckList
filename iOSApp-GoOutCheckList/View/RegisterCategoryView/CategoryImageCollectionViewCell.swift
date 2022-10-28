//
//  CategoryImageCollectionViewCell.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/28.
//

import UIKit

class CategoryImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var categoryImage: UIImageView!
    private var isSelectedImage: Bool = false

    func configure(image: UIImage?, isSelected: Bool) {
        if image != nil {
            self.categoryImage.image = image
            setupLayout()
        } else {
            self.categoryImage.image = UIImage(named: "unknownImage")
            setupLayout()
        }

        self.isSelectedImage = isSelected
        if isSelectedImage == true {
            self.backgroundColor = .black
        } else {
            self.backgroundColor = .none
        }
    }

    func isSelectedImage(isSelected: Bool) {

        self.isSelectedImage = isSelected
        if isSelectedImage == true {
            self.backgroundColor = .black
        } else {
            self.backgroundColor = .none
        }
    }

    private func setupLayout() {
        self.categoryImage.layer.cornerRadius = 10
        self.categoryImage.layer.masksToBounds = true
        self.categoryImage.layer.borderColor = UIColor.blue.cgColor
        self.categoryImage.layer.borderWidth = 2
    }

}
