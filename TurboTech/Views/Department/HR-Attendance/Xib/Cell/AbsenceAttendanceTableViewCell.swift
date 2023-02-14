//
//  AbsenceAttendanceTableViewCell.swift
//  TurboTech
//
//  Created by Sov Sothea on 6/10/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class AbsenceAttendanceTableViewCell: UITableViewCell {

    // IBOutlet of AbsenceAttendanceTableViewCell
    @IBOutlet weak var coverColorAbsenceAttendanceViewOutlet: UIView!
    @IBOutlet weak var lbNameAbsenceOutlet: UILabel!
    @IBOutlet weak var coverAbsenceAttendanceViewCellOutlet: UIView!
    @IBOutlet weak var editButton : UIButton!
    
    var onButtonPressed : (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()

        // Call Function
       customPresentAttendanceTableViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        coverColorAbsenceAttendanceViewOutlet.roundCorners(corners: [.topLeft, .bottomLeft], radius: SIZE.RADIUS)
    }

    func setData(_ data : AttendanceAbsence?){
        self.tag = data?.id ?? 0
        lbNameAbsenceOutlet.text = data?.name
        if let position = AppDelegate.user?.position, let department = AppDelegate.user?.department {
            switch position {
            case .assistantCEO, .hrAndAdmin, .ceo:
                self.editButton.isHidden = false
            default:
                switch department {
                case .TOP:
                    self.editButton.isHidden = false
                case .ITD, .FND, .BSD, .OPD, .NONE:
                    fallthrough
                default :
                    self.editButton.isHidden = true
                }
            }
        }
    }
    
    func isEditToFalse(){
        self.editButton.isHidden = true
    }

    func customPresentAttendanceTableViewCell() {
        coverAbsenceAttendanceViewCellOutlet.layer.cornerRadius = SIZE.RADIUS
        coverAbsenceAttendanceViewCellOutlet.layer.borderColor = COLOR.WHITE_SMOKE_GREY.cgColor
        coverAbsenceAttendanceViewCellOutlet.layer.borderWidth = 0.5

        coverColorAbsenceAttendanceViewOutlet.backgroundColor = COLOR.COLOR_ABSENCE
    }
    
    @IBAction func editPress(_ sender : UIButton){
        if let onPressed = self.onButtonPressed {
            onPressed()
        }
    }

}
