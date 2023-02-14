//
//  AttendanceAbsentCollectionViewCell.swift
//  TurboTech
//
//  Created by wo on 8/14/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class AttendanceAbsentCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var mainViewLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var mainVIewTrailingContraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView : UIView!
    
    @IBOutlet weak var absentStackView : UIStackView!
    @IBOutlet weak var absentContainerView : UIView!
    @IBOutlet weak var absentLabelView : UIView!
    @IBOutlet weak var absentLabel : UILabel!
    
    @IBOutlet weak var permissionStackView : UIStackView!
    @IBOutlet weak var permissionContainerView : UIView!
    @IBOutlet weak var permissionLabelView : UIView!
    @IBOutlet weak var permissionLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup(){
        self.absentLabelView.layer.cornerRadius = self.absentLabelView.frame.width / 2
        self.permissionLabelView.layer.cornerRadius = self.permissionLabelView.frame.width / 2
    }
    
    override func layoutSubviews() {
        self.absentContainerView.roundCorners(corners: [.allCorners], radius: SIZE.RADIUS)
        self.mainView.roundCorners(corners: [.allCorners
        ], radius: SIZE.RADIUS)
        self.permissionContainerView.roundCorners(corners: [.allCorners], radius: SIZE.RADIUS)
    }
    
    func setData(absent : Int, permission : Int){
        self.absentLabel.text = "\(absent)"
        self.permissionLabel.text = "\(permission)"
    }

}
