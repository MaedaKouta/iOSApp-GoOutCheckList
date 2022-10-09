//
//  RegisterCheckElementViewController.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/08.
//

import UIKit

class RegisterCheckItemViewController: UIViewController {

    @IBOutlet private weak var elementNameTextField: UITextField!

    /*
     登録ボタンが押された際に、前の画面のViewModel（CategoryTableViewModel）に値追加の通知を行う
     値変更の通知によって前画面のtableViewの要素が１つ増える
     前画面に戻る遷移を行う
     */
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
