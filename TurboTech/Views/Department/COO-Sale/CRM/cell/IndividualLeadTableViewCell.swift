//
//  IndividualLeadTableViewCell.swift
//  TurboTech
//
//  Created by sq on 6/29/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import LGButton

class IndividualLeadTableViewCell: UITableViewCell {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var customerNameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var convertButton: LGButton!
    var convertedLeadAction: ((String) -> ())?
    var id : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(lead : LeadAll) {
        customerNameLabel.text = lead.custmerName
        statusLabel.text = lead.status == "Cold" ? "In Process of Survey" : lead.status
        convertButton.isHidden = true
        var statusColor = UIColor.black
        switch lead.status {
            case "Cold" :
                statusColor = .green
//                print("Cold")
            case "Junk Lead" :
                statusColor = .gray
//                print("Junk Lead")
            case "Qualified" :
                statusColor = .cyan
                convertButton.isHidden = false
//                print("Qualified")
            case "Inquiry" :
                statusColor = .systemPink
//                print("Inquiry")
            case "Surveyed" :
                statusColor = .systemYellow
//                print("Surveyed")
            default :
                print("Def")
        }
        statusLabel.textColor = statusColor
        statusView.backgroundColor = statusColor
        convertButton.addTarget(self, action: #selector(convertLead(_:)), for: .touchUpInside)
    }
    
    @objc func convertLead(_ sender : Any){
        if let id = id {
            if let action = self.convertedLeadAction {
//                print("Touch hz : ", id)
                action(id)
            }
        }
    }
    
}
