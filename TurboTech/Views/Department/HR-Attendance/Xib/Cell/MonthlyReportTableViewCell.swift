//
//  MonthlyReportTableViewCell.swift
//  TurboTech
//
//  Created by wo on 9/12/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class MonthlyReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var statusView : UIView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.borderColor = UIColor.gray.cgColor
        self.containerView.layer.borderWidth = 0.5
        self.containerView.layer.cornerRadius = SIZE.RADIUS
    }
    
    override func layoutSubviews() {
        self.containerView.roundCorners(corners: UIRectCorner([.allCorners]), radius: SIZE.RADIUS_CARD)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ data : AttendanceReportDetail, _ isEarly : Bool){
        statusView.backgroundColor = isEarly ? COLOR.COLOR_PRESENT : COLOR.COLOR_LATE
        self.nameLabel.text = data.name
        self.timeLabel.text = data.second
    }
    
}
