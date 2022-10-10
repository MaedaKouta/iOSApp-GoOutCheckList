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

        if isDone {
            checkImage.image = UIImage(systemName: "circle.fill")
        } else {
            checkImage.image = UIImage(systemName: "circle")
        }
    }

    func isDoneItem(isDone: Bool) {
        if isDone {
            checkImage.image = UIImage(systemName: "circle.fill")
        } else {
            checkImage.image = UIImage(systemName: "circle")
        }
    }

}
