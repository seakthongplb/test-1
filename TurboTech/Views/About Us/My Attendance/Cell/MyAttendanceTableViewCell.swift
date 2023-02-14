//
//  MyAttendanceTableViewCell.swift
//  TurboTech
//
//  Created by wo on 9/4/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class MyAttendanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var dateView : UIView!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var dateOfWeekLabel : UILabel!
    @IBOutlet weak var amInLabel : UILabel!
    @IBOutlet weak var amOutLabel : UILabel!
    @IBOutlet weak var pmInLabel : UILabel!
    @IBOutlet weak var pmOutLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        self.setup()
    }
    
    private func setup(){
        self.containerView.layer.cornerRadius = SIZE.RADIUS_CARD
        self.dateView.layer.cornerRadius = SIZE.RADIUS_CARD
//        self.containerView.roundCorners(corners: UIRectCorner([.allCorners]), radius: SIZE.RADIUS_CARD)
//        self.dateView.roundCorners(corners: UIRectCorner([.allCorners]), radius: SIZE.RADIUS)
    }
    
    func setData(myAttendance data: MyAttendanceDetail, isToday : Bool){
        self.dateLabel.text = data.date
        self.dateOfWeekLabel.text = data.dayOfWeek
        self.amInLabel.text = data.amIn
        self.amOutLabel.text = data.amOut
        self.pmInLabel.text = data.pmIn
        self.pmOutLabel.text = data.pmOut
        if isToday {
            self.containerView.backgroundColor = COLOR.COLOR_PRESENT
            self.amInLabel.textColor = .white
            self.amOutLabel.textColor = .white
            self.pmInLabel.textColor = .white
            self.pmOutLabel.textColor = .white
        }
    }
    
}
