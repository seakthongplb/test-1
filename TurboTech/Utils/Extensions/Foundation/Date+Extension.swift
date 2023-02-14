//
//  Date+Extension.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation


enum FormatStringDate : String {
    case mmmddyyy = "MMM dd, yyy"
    case yyyymdd = "yyyy-M-dd"
    case mmmddyyy_hhmmss = "MMM dd, yyyy HH:mm:ss"
    // 2021-03-20 02:25:41.755113
    case yyyymdd_hhmmssZ = "yyyy-M-dd HH:mm:ss.SSS"
    case yyyymdd_hhmmss = "yyyy-M-dd HH:mm:ss"
}

extension Date {
    func toString(toFormat : FormatStringDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = toFormat.rawValue
        return formatter.string(from: self)
    }
}
