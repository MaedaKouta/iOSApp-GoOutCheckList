//
//  RegisterCheckElementViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/08.
//

import UIKit

class RegisterCheckElementViewController: UIViewController {

    @IBOutlet private weak var elementNameTextField: UITextField!

    @IBAction private func didTapRegisterButton(_ sender: Any) {
        guard let text = elementNameTextField.text else { return }
        let checkItem: CheckItem = CheckItem()
        checkItem.name = text

        NotificationCenter.default.post(
            name: Notification.Name.LostCheckViewFromRegisterViewNotification,
            object: checkItem
        )

        self.dismiss(animated: true, completion: nil)
    }
}
