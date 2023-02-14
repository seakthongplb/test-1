//
//  TicketHistoryTableViewCell.swift
//  TurboTech
//
//  Created by wo on 9/4/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class TicketHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var subContainerView : UIView!
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var updateLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setData(history : TicketHistory){
        self.userNameLabel.text = "\(history.user) \(history.mode)"
        self.updateLabel.text = "\(history.field) from \(history.from) to \(history.to) at \(history.modifiedTime)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        self.containerView.roundCorners(corners: [.allCorners], radius: SIZE.RADIUS)
        self.subContainerView.roundCorners(corners: [.allCorners], radius: SIZE.RADIUS)
        super.layoutSubviews()
    }
    
}
