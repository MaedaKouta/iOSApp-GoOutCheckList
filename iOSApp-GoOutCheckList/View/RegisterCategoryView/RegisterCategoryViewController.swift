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

    private var imageData: [CategoryImage] = [
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
        CategoryImage(image: UIImage(named: "car"), isSelected: false),
        CategoryImage(image: UIImage(named: "train"), isSelected: false),
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        categoryImageCollectionView.dataSource = self
        categoryImageCollectionView.delegate = self
        categoryImageCollectionView.register(UINib(nibName: "CategoryImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryImageCollectionViewCell")
    }

    /*
     ボタンタップでCategoryTableViewModelへ通知を送る。
     遷移元のtableViewへ反映させるために必要。
    */
    @IBAction private func didTapRegisterButton(_ sender: Any) {

        guard let text = categoryNameTextField.text else { return }
        let categoryItem = Category()
        categoryItem.name = text

        NotificationCenter.default.post(
            name: Notification.Name.CategoryViewFromRegisterViewNotification,
            object: categoryItem
        )

        self.dismiss(animated: true, completion: nil)
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
        return imageData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = categoryImageCollectionView
            .dequeueReusableCell(withReuseIdentifier: "CategoryImageCollectionViewCell", for: indexPath) as! CategoryImageCollectionViewCell
        cell.configure(image: imageData[indexPath.row].image, isSelected: imageData[indexPath.row].isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = categoryImageCollectionView.cellForItem(at: indexPath) as! CategoryImageCollectionViewCell
        imageData[indexPath.row].isSelected.toggle()
        cell.isSelectedImage(isSelected: imageData[indexPath.row].isSelected)
        print("タップされたよ\(indexPath)")
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true  // 変更
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true  // 変更
    }

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
