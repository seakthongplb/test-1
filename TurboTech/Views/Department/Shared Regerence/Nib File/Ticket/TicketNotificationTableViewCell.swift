//
//  TicketNotificationTableViewCell.swift
//  TurboTech
//
//  Created by sq on 7/15/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Kingfisher

class TicketNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var statusLabel : UILabel!
    @IBOutlet weak var gradientProfileView : UIView!
    @IBOutlet weak var whiteProfileView : UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientProfileView.roundCorners(corners: [.allCorners], radius: gradientProfileView.frame.size.width)
        whiteProfileView.roundCorners(corners: [.allCorners], radius: whiteProfileView.frame.size.width)
        profileImageView.roundCorners(corners: [.allCorners], radius: profileImageView.frame.size.width)
    }
    
    private func setup(){
        gradientProfileView.setColorGradient(colorOne: .systemPink, colorTwo: .systemTeal)
    }
    
    func setData( _ ticket : TicketNotification){
        titleLabel.text = ticket.subject == "" ? "NO SUBJECT" : ticket.subject
        descriptionLabel.text = ticket.description
        statusLabel.text = ticket.severity
        descriptionLabel.text = ticket.assigned_to
        timeLabel.text = ticket.modified_time
        self.profileImageView.kf.setImage(with: URL(string: ticket.imageUrl), placeholder: UIImage(named: "attendance-person"))
    }
    
}
