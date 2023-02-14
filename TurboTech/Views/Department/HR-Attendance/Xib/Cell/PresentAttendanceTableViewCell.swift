//
//  PresentAttendanceTableViewCell.swift
//  TurboTech
//
//  Created by Sov Sothea on 6/10/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PresentAttendanceTableViewCell: UITableViewCell {
    
    // IBOutlet of PresentAttendanceTableViewCell
    @IBOutlet weak var lbTimePresentOutlet: UILabel!
    @IBOutlet weak var lbNamePresentOutlet: UILabel!
    @IBOutlet weak var lbNameStatusPresentOutlet: UILabel!
    @IBOutlet weak var coverPresentAttendanceViewCellOutlet: UIView!
    @IBOutlet weak var coverColorPresentAttendanceViewCellOutlet: UIView!
    @IBOutlet weak var editableButton : UIButton!
    
    var onButtonPressed : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Call Function
        customPresentAttendanceTableViewCell()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData(_ present : AttendancePresent, isPresent : Bool, isHiddenButton : Bool = false){
        lbNamePresentOutlet.text = present.name
        lbTimePresentOutlet.text = present.time
        lbNameStatusPresentOutlet.text = present.stateName.lowercased().localized
        coverColorPresentAttendanceViewCellOutlet.backgroundColor = isPresent ? COLOR.COLOR_PRESENT : COLOR.COLOR_LATE
        editableButton.isHidden = isHiddenButton
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverColorPresentAttendanceViewCellOutlet.roundCorners(corners: [.topLeft, .bottomLeft], radius: SIZE.RADIUS)
    }
    
    func customPresentAttendanceTableViewCell() {
        coverPresentAttendanceViewCellOutlet.layer.cornerRadius = SIZE.RADIUS
        coverPresentAttendanceViewCellOutlet.layer.borderColor = COLOR.WHITE_SMOKE_GREY.cgColor
        coverPresentAttendanceViewCellOutlet.layer.borderWidth = 0.5
    }
    
    @IBAction func editPress(_ sender : UIButton){
        if let onPressed = self.onButtonPressed {
            onPressed()
        }
    }
    
}
