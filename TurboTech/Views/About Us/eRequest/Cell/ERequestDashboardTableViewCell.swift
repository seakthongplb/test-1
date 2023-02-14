//
//  ERequestDashboardTableViewCell.swift
//  TurboTech
//
//  Created by Mr. iSQ on 3/19/21.
//  Copyright © 2021 TurboTech. All rights reserved.
//

import UIKit

class ERequestDashboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstlabel : UILabel!
    @IBOutlet weak var secondLabel : UILabel!
    @IBOutlet weak var containerView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        setup()
    }
    
    private func setup(){
        containerView.roundCorners(corners: [.allCorners], radius: SIZE.RADIUS_CARD)
    }
    
    func setData(firstLabel fl : String, secondLabel sl : String, color : UIColor) {
        firstlabel.text = fl
        firstlabel.textColor = color == .white ? COLOR.COLOR_PRESENT : .white
        secondLabel.text = sl
        secondLabel.textColor = color == .white ? COLOR.COLOR_PRESENT : .white
        containerView.backgroundColor = color
    }
    
}
