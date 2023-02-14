//
//  MonthYearPicketView.swift
//  TurboTech
//
//  Created by wo on 9/10/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit


//// TODO: - https://stackoverflow.com/questions/32580005/how-to-accept-only-month-and-year-using-datepicker-in-ios -
class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var months: [String]!
    var years: [Int]!

    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }

    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.firstIndex(of: year)!, inComponent: 1, animated: true)
        }
    }

    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func setYear(fromYear start : Int, toYear end : Int){
        var n = (end  - start)
        var year = start
        
        if n < -1 {
            n *= -1
            year = end
        }
        
        var customYears = [Int]()
        for _ in 0...n {
            customYears.append(year)
            year += 1
        }
        
        self.years = customYears
        self.reloadAllComponents()
    }

    func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...10 {
                years.append(year)
                year += 1
            }
        }
        self.years = years

        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months

        self.delegate = self
        self.dataSource = self

        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
    }

    // Mark: UIPicker Delegate / Data Source

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row].lowercased().localized
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: 0)+1
        let year = years[self.selectedRow(inComponent: 1)]
        
        let date = Date()
        let calendar = Calendar.current
        let m = calendar.component(.month, from: date)
        let y = calendar.component(.year, from: date)
        if year > y {
            let yIndex = years.firstIndex(of: y) ?? 0
            pickerView.selectRow(yIndex, inComponent: 1, animated: true)
            self.pickerView(pickerView, didSelectRow: yIndex, inComponent: 1)
            self.month = month
            self.year = years[yIndex]
        } else if year == y && month > m {
            pickerView.selectRow(m-1, inComponent: 0, animated: true)
            self.pickerView(pickerView, didSelectRow: m, inComponent: 0)
            self.month = m
            self.year = year
        } else {
            self.month = month
            self.year = year
        }
        
        if let block = onDateSelected {
            block(self.month, self.year)
        }
    }

}

