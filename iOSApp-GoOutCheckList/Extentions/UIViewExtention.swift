//
//  UIViewExtention.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/30.
//

import Foundation
import UIKit

extension UIView {

    func draw(text: String, rect: CGRect) {
        text.draw(at: CGPoint(x: 0, y: 0), withAttributes: [
            NSAttributedString.Key.foregroundColor : UIColor.blue,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 50),
        ])
    }

}
