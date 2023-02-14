//
//  ERequestDetailFeedbackTableViewCell.swift
//  TurboTech
//
//  Created by Mr. iSQ on 3/20/21.
//  Copyright © 2021 TurboTech. All rights reserved.
//

import UIKit

class ERequestDetailFeedbackTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var statusLabel : UILabel!
    @IBOutlet weak var commentLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        setup()
    }
    
    private func setup(){
        containerView.roundCorners(corners: [.allCorners], radius: SIZE.RADIUS_CARD)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func setData(erd : ERequestDetail) {
        self.nameLabel.text = erd.actionByName
        self.statusLabel.text = erd.eRequestStatus
        self.commentLabel.text = erd.comment
        self.dateLabel.text = erd.date
        statusLabel.textColor = erd.eRequestStatus == "approve" ? .green : erd.eRequestStatus == "pending" ? COLOR.COLOR_LATE : erd.eRequestStatus == "reject" ? .red : .gray
    }
    
}
