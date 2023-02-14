//
//  OwnRequestTableViewCell.swift
//  TurboTech
//
//  Created by Mr. iSQ on 3/19/21.
//  Copyright © 2021 TurboTech. All rights reserved.
//

import UIKit

class OwnRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var requestFormNameLabel : UILabel!
    @IBOutlet weak var requestDateLabel : UILabel!
    @IBOutlet weak var statusLabel : UILabel!
    
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
    
    func setData(eRequest er : ERequest) {
        requestFormNameLabel.text = er.formName
        requestDateLabel.text = er.createDate
        statusLabel.text = er.eRequestStatus
        statusLabel.textColor = er.eRequestStatus == "approve" ? .green : er.eRequestStatus == "pending" ? COLOR.COLOR_LATE : er.eRequestStatus == "reject" ? .red : .gray
    }
    
}
