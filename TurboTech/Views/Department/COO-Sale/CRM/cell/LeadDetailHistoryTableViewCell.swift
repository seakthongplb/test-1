//
//  LeadDetailHistoryTableViewCell.swift
//  TurboTech
//
//  Created by wo on 9/10/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class LeadDetailHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var fieldLabel : UILabel!
    @IBOutlet weak var fromLabel : UILabel!
    @IBOutlet weak var toLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = SIZE.RADIUS
        self.containerView.layer.borderColor = UIColor.gray.cgColor
        self.containerView.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(history : LeadHistory){
        self.usernameLabel.text = "\(history.user) \(history.mode)"
        self.fieldLabel.text = "\("field".localized): \(history.field)"
        self.fromLabel.text = "\("from".localized): \(history.from)"
        self.toLabel.text = "\("to".localized): \(history.to)"
        self.timeLabel.text = ""
    }
    
}
