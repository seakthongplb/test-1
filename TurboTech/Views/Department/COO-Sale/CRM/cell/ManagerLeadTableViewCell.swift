//
//  ManagerLeadTableViewCell.swift
//  TurboTech
//
//  Created by sq on 6/29/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import LGButton

class ManagerLeadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customerNameLabel : UILabel!
    @IBOutlet weak var assignedToLabel : UILabel!
    @IBOutlet weak var statusLabel : UILabel!
    @IBOutlet weak var convertButton : LGButton!
    @IBOutlet weak var statusView : UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    var convertedLeadAction : ((String)->())?
    var id : String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        
    }
    
    func setData(lead : LeadAll) {
        customerNameLabel.text = lead.custmerName
        assignedToLabel.text = "assign to".localized + " : " + lead.assignTo
        statusLabel.text = lead.status == "Cold" ? "In Process of Survey" : lead.status
        convertButton.isHidden = true
        var statusColor = UIColor.black
        switch lead.status {
            case "Cold" :
                statusColor = .green
            case "Junk Lead" :
                statusColor = .gray
            case "Qualified" :
                statusColor = .cyan
                convertButton.isHidden = false
            case "Inquiry" :
                statusColor = .systemPink
            case "Surveyed" :
                statusColor = .systemYellow
            default :
                statusColor = .white
        }
        
        statusLabel.textColor = statusColor
        statusView.backgroundColor = statusColor
        convertButton.addTarget(self, action: #selector(convertLead(_:)), for: .touchUpInside)
        }
        
        @objc func convertLead(_ sender : Any){
            if let id = id {
                if let action = self.convertedLeadAction {
//                    print("Touch hz : ", id)
                    action(id)
                }
            }
        }
    
}
