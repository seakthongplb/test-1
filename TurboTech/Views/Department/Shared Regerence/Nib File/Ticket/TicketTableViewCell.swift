//
//  TicketTableViewCell.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import SwipeCellKit

class TicketTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var ticketSubjectLabel: UILabel!
    @IBOutlet weak var ticketStatusLabel: UILabel!
    @IBOutlet weak var ticketStatusView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func setup(){
    }
    
    func setData(ticket : TicketNotification){
        ticketSubjectLabel.text = ticket.subject
        ticketStatusLabel.text = ticket.status
        switch ticket.status {
        case "Open":
            ticketStatusView.backgroundColor = .systemPink
        case "In Progress" :
            ticketStatusView.backgroundColor = .systemYellow
        case "Wait For Response" :
            ticketStatusView.backgroundColor = .gray
        case "Closed" :
            ticketStatusView.backgroundColor = .blue
        default:
            ticketStatusView.backgroundColor = .white
        }
    }
}
