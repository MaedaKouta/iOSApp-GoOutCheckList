//
//  RegisterCategoryDetailViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/06.
//

import UIKit

struct CategoryImage {
    var image: UIImage?
    var isSelected: Bool
}

class RegisterCategoryViewController: UIViewController {

    @IBOutlet private weak var categoryNameTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var categoryImageCollectionView: UICollectionView!

    private var categoryImages: [CategoryImage] = [
        CategoryImage(image: UIImage(named: "walk_small"), isSelected: true),
        CategoryImage(image: UIImage(named: "baby_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "bath_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "beer_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "brain_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "building_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "car_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "cherry_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "cupple_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "deskwork_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "dog_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "forest_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "guitar_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "hammer_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "house_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "human_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "meeting_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "muscle_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "notebook_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "presentation_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "sleepy_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "textboard_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "train_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "truip_small"), isSelected: false),
        CategoryImage(image: UIImage(named: "question_small"), isSelected: false),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryImageCollectionView.dataSource = self
        categoryImageCollectionView.delegate = self
        categoryImageCollectionView.register(UINib(nibName: "CategoryImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryImageCollectionViewCell")

        let tapElseView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapElseView(_:)))
        tapElseView.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapElseView)
    }

    /*
     ボタンタップでCategoryTableViewModelへ通知を送る。
     遷移元のtableViewへ反映させるために必要。
    */
    @IBAction private func didTapRegisterButton(_ sender: Any) {

        guard let text = categoryNameTextField.text else { return }
        let categoryItem = Category()
        let image: CategoryImage? = categoryImages.filter{ $0.isSelected == true }.first

        categoryItem.name = text
        categoryItem.imageData = image?.image?.pngData()

        NotificationCenter.default.post(
            name: Notification.Name.CategoryViewFromRegisterViewNotification,
            object: categoryItem
        )

        self.dismiss(animated: true, completion: nil)
    }

    @objc private func didTapElseView(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }

}

extension RegisterCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = categoryImageCollectionView
            .dequeueReusableCell(withReuseIdentifier: "CategoryImageCollectionViewCell", for: indexPath) as! CategoryImageCollectionViewCell
        cell.configure(image: categoryImages[indexPath.row].image, isSelected: categoryImages[indexPath.row].isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = categoryImageCollectionView.cellForItem(at: indexPath) as! CategoryImageCollectionViewCell

        // imageDataを全てfalseにする
        self.categoryImages.indices.forEach { self.categoryImages[$0].isSelected = false }
        // 選択されたimageDataをひっくり返す
        categoryImages[indexPath.row].isSelected.toggle()
        cell.isSelectedImage(isSelected: categoryImages[indexPath.row].isSelected)

        categoryImageCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

}
