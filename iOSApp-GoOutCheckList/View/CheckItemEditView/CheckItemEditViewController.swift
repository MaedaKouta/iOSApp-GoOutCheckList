//
//  CheckItemEditViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/11/09.
//

import UIKit

class CheckItemEditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var itemNameTextField: UITextField!
    @IBOutlet private weak var registerButtonView: TouchFeedbackView!
    @IBOutlet private weak var closeButton: UIButton!
    private let softFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)

    private let oldItemName: String!
    private let index: Int!

    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.text = "上書き"
        label.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha:1)
        label.frame = CGRect(x: 0, y: 0, width: 160, height: 50)
        label.font =  UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.red
        return label
    }()

    init(itemName: String, index: Int) {
        self.oldItemName = itemName
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRegisterButtonView()
        setupItemNameTextField()
        setupCloseButton()
    }

    // MARK: Actions
    @IBAction func didChangedItemNameTextField(_ sender: Any) {
        guard let itemNameText = itemNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}

        // 値が前と同じなら上書きボタン押せなくする
        if itemNameText == oldItemName {
            isAvailableRegisterButton(isAvailable: false)
            return
        }

        if itemNameText.isEmpty {
            isAvailableRegisterButton(isAvailable: false)
        } else {
            isAvailableRegisterButton(isAvailable: true)
        }
    }

    /*
     登録ボタンが押された際に、前の画面のViewModel（CategoryTableViewModel）に値追加の通知を行う
     値変更の通知によって前画面のtableViewの要素が１つ増える
     前画面に戻る遷移を行う
     */
    @objc private func didTapRegisterButtonView(_ sender: UIBarButtonItem) {
        guard let text = itemNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        softFeedbackGenerator.impactOccurred()

        NotificationCenter.default.post(
            name: Notification.Name.CheckItemViewFromEditOverwriteNotification,
            object: nil,
            userInfo: ["index": index!, "itemName": text]
        )
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func didTapElseView(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemNameTextField.resignFirstResponder()
        return true
    }

    // MARK: Setups
    private func setupRegisterButtonView() {
        registerButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRegisterButtonView(_:))))
        registerButtonView.addSubview(registerLabel)

        isAvailableRegisterButton(isAvailable: false)
    }

    private func setupItemNameTextField(){
        itemNameTextField.delegate = self
        itemNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        itemNameTextField.becomeFirstResponder()
        itemNameTextField.text = oldItemName

        // 余白タッチでキーボード閉じる
        let tapElseView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapElseView(_:)))
        tapElseView.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapElseView)
    }

    private func setupCloseButton() {
        closeButton.setImage(UIImage(systemName: "x.circle.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20))), for: .normal)
        closeButton.tintColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha:1)
    }

    // MARK: Methods
    private func isAvailableRegisterButton(isAvailable: Bool) {
        if isAvailable {
            registerLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha:1)
            registerButtonView.backgroundColor = UIColor.white
            registerButtonView.tintColor = .darkGray
            registerButtonView.layer.cornerRadius = 25.0
            registerButtonView.layer.shadowColor = UIColor.black.cgColor
            registerButtonView.layer.shadowRadius = 10
            registerButtonView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
            registerButtonView.layer.shadowOpacity = 0.35
            registerButtonView.isUserInteractionEnabled = true
        } else {
            registerLabel.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha:1)
            registerButtonView.backgroundColor = UIColor.white
            registerButtonView.tintColor = .darkGray
            registerButtonView.layer.cornerRadius = 25.0
            registerButtonView.layer.shadowColor = UIColor.black.cgColor
            registerButtonView.layer.shadowRadius = 10
            registerButtonView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            registerButtonView.layer.shadowOpacity = 0.15
            registerButtonView.isUserInteractionEnabled = false

        }
    }

}

