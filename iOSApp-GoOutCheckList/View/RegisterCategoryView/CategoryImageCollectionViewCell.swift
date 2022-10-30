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
    let selectLayerColor: CGColor = CGColor.init(red: 90/256, green: 90/256, blue: 90/256, alpha: 1.0)
    let noneSelectLayerColor: CGColor = CGColor.init(red: 90/256, green: 90/256, blue: 90/256, alpha: 0.3)

    func configure(image: UIImage?, isSelected: Bool) {
        if image != nil {
            self.categoryImage.image = image
            setupLayout()
        } else {
            self.categoryImage.image = UIImage(named: "unknownImage")
            setupLayout()
        }

        isSelectedImage(isSelected: isSelected)
    }

    private func isSelectedImage(isSelected: Bool) {
        self.isSelectedImage = isSelected

        if isSelectedImage {
            UIView.animate(withDuration: 0.25, delay: 0, animations: { [weak self]  in
                self?.categoryImage.layer.borderColor = self?.selectLayerColor
                self?.categoryImage.alpha = CGFloat(1.0)
            })
        } else {
            self.categoryImage.layer.borderColor = self.noneSelectLayerColor
            self.categoryImage.alpha = CGFloat(0.55)
        }

    }

    private func setupLayout() {
        self.categoryImage.layer.cornerRadius = 10
        self.categoryImage.layer.masksToBounds = true
        self.categoryImage.layer.borderColor = noneSelectLayerColor
        self.categoryImage.layer.borderWidth = 2
    }

}
