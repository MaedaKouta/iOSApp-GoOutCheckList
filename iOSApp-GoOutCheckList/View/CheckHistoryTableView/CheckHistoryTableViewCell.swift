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

    func setConfigure(dateText: String, categoryText: String) {
        dateTextLabel.text = dateText
        categoryTextLabel.text = categoryText
    }

}
