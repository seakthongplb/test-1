//
//  PopDetailTableViewCell.swift
//  TurboTech
//
//  Created by wo on 7/22/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PopDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var productImageCircleView : UIView!
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var productLabel : UILabel!
    @IBOutlet weak var qtyUnitLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        self.setup()
    }
    
    private func setup(){
        self.productImageCircleView.roundCorners(corners: UIRectCorner([.allCorners]), radius: self.productImageCircleView.frame.height / 2)
        self.productImageView.roundCorners(corners: UIRectCorner([.allCorners]), radius: self.productImageView.frame.height / 2)
        self.containerView.roundCorners(corners: UIRectCorner([.allCorners]), radius: SIZE.RADIUS_CARD)
        self.containerView.layer.borderWidth = 0.5
        self.containerView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setData(_ pop : PopProduct) {
        self.productLabel.text = "\(pop.product)"
        self.qtyUnitLabel.text = "\(pop.qty) \(pop.unit)"
    }
    
}
