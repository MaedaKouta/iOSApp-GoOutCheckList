//
//  CategoryImageCollectionViewCell.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/28.
//

import UIKit

class CategoryImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var categoryImage: UIImageView!

    func configure(image: UIImage?) {
        if image != nil {
            self.categoryImage.image = image
        } else {
            self.categoryImage.image = UIImage(named: "unknownImage")
        }
    }

}
