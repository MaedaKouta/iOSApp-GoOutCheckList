//
//  RegisterCategoryDetailViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/06.
//

import UIKit

class RegisterCategoryViewController: UIViewController {

    @IBOutlet private weak var categoryNameTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!

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