//
//  DateUtils.swift
//  iOSApp-GoOutCheckList
//
//  Created by 前田航汰 on 2022/10/28.
//

import UIKit

public class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        formatter.locale = NSLocale.system
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        formatter.locale = NSLocale.system
        return formatter.string(from: date)
    }

}
