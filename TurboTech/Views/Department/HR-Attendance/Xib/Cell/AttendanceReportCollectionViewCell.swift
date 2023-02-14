//
//  AttendanceReportCollectionViewCell.swift
//  TurboTech
//
//  Created by sq on 6/22/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class AttendanceReportCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var reportTitleLabel: UILabel!
    @IBOutlet weak var leadingCoverConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var trailingCoverConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var coverAttendanceViewCellOutlet: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
        coverAttendanceViewCellOutlet.layer.cornerRadius = 10
        reportTitleLabel.text = "report".localized
        coverAttendanceViewCellOutlet.layer.borderColor = COLOR.WHITE_SMOKE_GREY.cgColor
        coverAttendanceViewCellOutlet.layer.borderWidth = 1.0
    }
}
