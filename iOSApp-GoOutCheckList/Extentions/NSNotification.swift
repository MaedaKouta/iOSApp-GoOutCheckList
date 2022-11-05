//
//  File.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/07.
//

import Foundation

extension NSNotification.Name {
    static var CategoryViewFromRegisterViewNotification = NSNotification.Name(rawValue: "CategoryViewFromRegisterViewNotification")
    static var CheckItemViewFromRegisterViewNotification = NSNotification.Name(rawValue: "CheckItemViewFromRegisterViewNotification")
    static var CategoryViewFromDataSourceDeleteNotification = NSNotification.Name(rawValue: "CategoryViewFromDataSourceDeleteNotification")
    static var CategoryViewFromDataSourceOverwriteNotification = NSNotification.Name(rawValue: "CategoryViewFromDataSourceOverwriteNotification")
    static var CheckItemViewFromDataSourceDeleteNotification = NSNotification.Name(rawValue: "CheckItemViewFromDataSourceDeleteNotification")
    static var CheckItemViewFromDataSourceOverwriteNotification = NSNotification.Name(rawValue: "CheckItemViewFromDataSourceOverwriteNotification")
}
