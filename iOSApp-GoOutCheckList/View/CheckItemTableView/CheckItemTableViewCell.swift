import UIKit

class CheckItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var checkImage: UIImageView!

    func configure(name: String, isDone: Bool) {
        itemNameLabel.text = name
        checkImage.tintColor = UIColor.customIconCircleColor
        itemNameLabel.adjustsFontSizeToFitWidth = true

        if isDone {
            checkImage.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            checkImage.image = UIImage(systemName: "circle")
        }
    }
}
