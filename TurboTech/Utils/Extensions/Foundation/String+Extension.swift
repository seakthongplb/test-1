//
//  StringExtension.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

extension String {
    var phoneNumber : String {
        if self.first == "0" {
            return "+855\(self.dropFirst())"
        } else {
            return self
        }
    }
    
    func toDate(fromDateFormat fdf : FormatStringDate, toFormat : FormatStringDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = fdf.rawValue
        guard let date = formatter.date(from: self) else { return "-" }
        formatter.dateFormat = toFormat.rawValue
        return formatter.string(from: date)
    }
    
    func toDate(format : FormatStringDate = .yyyymdd_hhmmss) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.date(from: self)
    }
}
