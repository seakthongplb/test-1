//
//  AttendanceCollectionViewCell.swift
//  TurboTech
//
//  Created by Sov Sothea on 5/27/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class AttendanceCollectionViewCell: UICollectionViewCell {
    
    // IBOutlet of AttendanceCollectionViewCell
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leadingCoverConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var trailingCoverConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var morningAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Call Function
        customAttendanceCollectionViewCell()
    }
    
    
    func customAttendanceCollectionViewCell() {
        backgroundCellView.layer.cornerRadius = 10
        backgroundCellView.layer.borderColor = COLOR.WHITE_SMOKE_GREY.cgColor
        backgroundCellView.layer.borderWidth = 1.0
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        
        
    }
    
    func setData(title : String, value : Int, imageName : String){
        self.titleLabel.text = title
        self.morningAmountLabel.text = "\(value)"
        profileImageView.image = UIImage(named: imageName)
    }
}


