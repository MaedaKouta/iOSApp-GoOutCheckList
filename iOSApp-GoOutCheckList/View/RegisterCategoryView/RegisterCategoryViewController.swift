//
//  RegisterCategoryDetailViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/06.
//

import UIKit

struct CategoryImage {
    var assetsImageName: String
    var isSelected: Bool
}

class RegisterCategoryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var categoryNameTextField: DoneTextField!
    @IBOutlet private weak var categoryImageCollectionView: UICollectionView!
    @IBOutlet private weak var registerButtonView: TouchFeedbackView!
    @IBOutlet private weak var closeButton: UIButton!
    private let softFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)

    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.text = "登録"
        label.textColor = UIColor.customMainColor
        //label.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        label.frame = CGRect(x: 0, y: 0, width: 160, height: 50)
        label.font =  UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.red
        return label
    }()

    private var categoryImages: [CategoryImage] = [
        CategoryImage(assetsImageName: "walk_small", isSelected: true),
        CategoryImage(assetsImageName: "baby_small", isSelected: false),
        CategoryImage(assetsImageName: "bath_small", isSelected: false),
        CategoryImage(assetsImageName: "beer_small", isSelected: false),
        CategoryImage(assetsImageName: "brain_small", isSelected: false),
        CategoryImage(assetsImageName: "building_small", isSelected: false),
        CategoryImage(assetsImageName: "car_small", isSelected: false),
        CategoryImage(assetsImageName: "cherry_small", isSelected: false),
        CategoryImage(assetsImageName: "cupple_small", isSelected: false),
        CategoryImage(assetsImageName: "deskwork_small", isSelected: false),
        CategoryImage(assetsImageName: "dog_small", isSelected: false),
        CategoryImage(assetsImageName: "forest_small", isSelected: false),
        CategoryImage(assetsImageName: "guitar_small", isSelected: false),
        CategoryImage(assetsImageName: "hammer_small", isSelected: false),
        CategoryImage(assetsImageName: "house_small", isSelected: false),
        CategoryImage(assetsImageName: "human_small", isSelected: false),
        CategoryImage(assetsImageName: "meeting_small", isSelected: false),
        CategoryImage(assetsImageName: "muscle_small", isSelected: false),
        CategoryImage(assetsImageName: "notebook_small", isSelected: false),
        CategoryImage(assetsImageName: "presentation_small", isSelected: false),
        CategoryImage(assetsImageName: "sleepy_small", isSelected: false),
        CategoryImage(assetsImageName: "textboard_small", isSelected: false),
        CategoryImage(assetsImageName: "train_small", isSelected: false),
        CategoryImage(assetsImageName: "truip_small", isSelected: false),
        CategoryImage(assetsImageName: "question_small", isSelected: false),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCategoryImageCollectionView()
        setupCategoryNameTextField()
        setupCloseButton()
        setupRegisterButtonView()
    }

    // MARK: Actions
    @IBAction func didChangedCategoryTextField(_ sender: Any) {
        guard let categoryNameText = categoryNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        if categoryNameText.isEmpty {
            isAvailableRegisterButton(isAvailable: false)
        } else {
            isAvailableRegisterButton(isAvailable: true)
        }
    }

    /*
     ボタンタップでCategoryTableViewModelへ通知を送る。
     遷移元のtableViewへ反映させるために必要。
    */
    @objc private func didTapRegisterButtonView(_ sender: UIBarButtonItem) {
        guard let text = categoryNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        let categoryItem = Category()
        let image: CategoryImage? = categoryImages.filter{ $0.isSelected == true }.first
        categoryItem.name = text
        categoryItem.assetsImageName = image?.assetsImageName ?? "question_small"
        softFeedbackGenerator.impactOccurred()

        NotificationCenter.default.post(
            name: Notification.Name.CategoryViewFromRegisterViewNotification,
            object: categoryItem
        )
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func didTapElseView(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryNameTextField.resignFirstResponder()
        return true
    }

    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Setups
    private func setupRegisterButtonView() {
        registerButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRegisterButtonView(_:))))
        registerButtonView.addSubview(registerLabel)

        isAvailableRegisterButton(isAvailable: false)
    }

    private func setupCategoryImageCollectionView(){
        categoryImageCollectionView.dataSource = self
        categoryImageCollectionView.delegate = self
        categoryImageCollectionView.register(UINib(nibName: "CategoryImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryImageCollectionViewCell")
    }

    private func setupCategoryNameTextField(){
        categoryNameTextField.delegate = self
        categoryNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing

        categoryNameTextField.becomeFirstResponder()
        // 余白タッチでキーボード閉じる
        let tapElseView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapElseView(_:)))
        tapElseView.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapElseView)
    }

    private func setupCloseButton() {
        closeButton.setImage(UIImage(systemName: "x.circle.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))), for: .normal)
        closeButton.tintColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
    }

    // MARK: Methods
    private func isAvailableRegisterButton(isAvailable: Bool) {
        if isAvailable {
            registerLabel.textColor = UIColor.customButtonTextColor
            registerButtonView.backgroundColor = UIColor.customButtonBackGroundColor
            registerButtonView.tintColor = .darkGray
            registerButtonView.layer.cornerRadius = 25.0
            registerButtonView.layer.shadowColor = UIColor.label.cgColor
            registerButtonView.layer.shadowRadius = 10
            registerButtonView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
            registerButtonView.layer.shadowOpacity = 0.35
            registerButtonView.isUserInteractionEnabled = true
        } else {
            registerLabel.textColor = UIColor.customButtonTextFalseColor
            registerButtonView.backgroundColor = UIColor.customButtonBackGroundFalseColor
            registerButtonView.tintColor = .darkGray
            registerButtonView.layer.cornerRadius = 25.0
            registerButtonView.layer.shadowColor = UIColor.label.cgColor
            registerButtonView.layer.shadowRadius = 10
            registerButtonView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            registerButtonView.layer.shadowOpacity = 0.15
            registerButtonView.isUserInteractionEnabled = false

        }
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
        cell.configure(image: UIImage(named: categoryImages[indexPath.row].assetsImageName), isSelected: categoryImages[indexPath.row].isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // imageDataを全てfalseにする
        self.categoryImages.indices.forEach { self.categoryImages[$0].isSelected = false }
        // 選択されたimageDataをひっくり返す
        categoryImages[indexPath.row].isSelected.toggle()
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
