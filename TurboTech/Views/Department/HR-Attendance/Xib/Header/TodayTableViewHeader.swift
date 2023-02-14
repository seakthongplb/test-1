//
//  OverallTableViewHeader.swift
//  TurboTech
//
//  Created by Sov Sothea on 6/11/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class TodayTableViewHeader : UITableViewHeaderFooterView {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    func setData(date : String, statusNumber : String){
        print(date, statusNumber)
        dateLabel.text = date
        numberLabel.text = statusNumber
    }
}
