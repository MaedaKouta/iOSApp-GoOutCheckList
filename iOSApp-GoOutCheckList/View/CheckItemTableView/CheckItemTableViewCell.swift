//
//  CheckItemTableViewCell.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/07.
//

import UIKit

class CheckItemTableViewCell: UITableViewCell {

    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var checkImage: UIImageView!

    func configure(name: String, isDone: Bool) {
        itemNameLabel.text = name
        checkImage.tintColor = UIColor.customMainColor
        itemNameLabel.adjustsFontSizeToFitWidth = true

        if isDone {
            checkImage.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            checkImage.image = UIImage(systemName: "circle")
        }
    }

    // 挙動がバグるから使用していない
    private func animateImageView(toImage: UIImage?) {
        if self.checkImage != toImage {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.1)

            let transition = CATransition()
            transition.type = CATransitionType.fade

            checkImage.layer.add(transition, forKey: kCATransition)
            checkImage.image = toImage
            CATransaction.commit()
        }

    }

}
