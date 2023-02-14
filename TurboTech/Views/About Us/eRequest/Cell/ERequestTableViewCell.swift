//
//  ERequestTableViewCell.swift
//  TurboTech
//
//  Created by Mr. iSQ on 3/17/21.
//  Copyright © 2021 TurboTech. All rights reserved.
//

import UIKit

class ERequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var titleLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        setup()
    }
    
    private func setup(){
        containerView.roundCorners(corners: [.allCorners], radius: SIZE.RADIUS_CARD)
    }
    
    func setup(title : String, isActive : Bool){
        if isActive {
            self.containerView.backgroundColor = .white
        }
        self.titleLabel.text = title
    }
    
}
