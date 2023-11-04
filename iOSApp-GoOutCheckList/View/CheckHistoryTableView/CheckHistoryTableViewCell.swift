import UIKit
import RealmSwift

class CheckHistoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var dateTextLabel: UILabel!
    @IBOutlet private weak var categoryTextLabel: UILabel!
    @IBOutlet private weak var dateBackgroundView: UIView!
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var newBackGroundView: UIView!
    @IBOutlet private weak var newTextLabel: UILabel!

    private let categoryObject = RealmManager().realm.objects(Category.self)

    func setConfigure(dateText: String, categoryId: String, isWatched: Bool) {

        let predicate = NSPredicate(format: "id == %@", categoryId)
        let categoryObject = categoryObject.filter(predicate).first

        dateTextLabel.text = dateText
        categoryTextLabel.text = categoryObject?.name

        if categoryObject?.assetsImageName != nil {
            self.categoryImageView.image = UIImage(named: categoryObject!.assetsImageName)
        } else {
            self.categoryImageView.image = UIImage(named: "question_small")
        }

        setupLayout()
        setupNewView(isWatched: isWatched)
    }

    private func setupNewView(isWatched: Bool) {
        if isWatched == true {
            newBackGroundView.isHidden = true
            newTextLabel.isHidden = true
        } else {
            newBackGroundView.isHidden = false
            newTextLabel.isHidden = false
        }
    }

    private func setupLayout() {
        dateTextLabel.adjustsFontSizeToFitWidth = true
        categoryTextLabel.adjustsFontSizeToFitWidth = true

        dateBackgroundView.backgroundColor = UIColor.systemBackground
        dateBackgroundView.tintColor = .darkGray
        dateBackgroundView.layer.cornerRadius = 5
        dateBackgroundView.layer.borderColor = UIColor.label.cgColor
        dateBackgroundView.layer.borderWidth = 0.50

        newBackGroundView.backgroundColor = UIColor.systemBackground
        newBackGroundView.tintColor = .darkGray
        newBackGroundView.layer.cornerRadius = 5
        newBackGroundView.layer.shadowColor = UIColor.label.cgColor
        newBackGroundView.layer.shadowRadius = 1
        newBackGroundView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        newBackGroundView.layer.shadowOpacity = 1.0
        newBackGroundView.layer.borderColor = UIColor.label.cgColor
        newBackGroundView.layer.borderWidth = 0.25

        categoryImageView.layer.cornerRadius = 13
        categoryImageView.layer.masksToBounds = true
        categoryImageView.layer.borderColor = UIColor.customIconCircleColor?.cgColor
        categoryImageView.layer.borderWidth = 1
    }
}
