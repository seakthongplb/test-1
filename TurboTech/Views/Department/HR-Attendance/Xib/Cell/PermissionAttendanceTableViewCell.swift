//
//  PermissionAttendanceTableViewCell.swift
//  TurboTech
//
//  Created by Mr. iSQ on 12/2/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PermissionAttendanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var approverLabel : UILabel!
    @IBOutlet weak var updaterLabel : UILabel!
    @IBOutlet weak var cellColorView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cellColorView.roundCorners(corners: [.topLeft, .bottomLeft], radius: SIZE.RADIUS)
    }
    
    public func setData(permission : AttendanceAbsence?){
        self.nameLabel.text = permission?.name
        self.approverLabel.text = "approved by".localized + " : " + (permission?.approver ?? "")
        self.updaterLabel.text = "update by".localized + " : " + (permission?.editor ?? "")
        self.tag = permission?.id ?? 0
    }
    
}
