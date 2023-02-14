//
//  PaymentTableViewCell.swift
//  TurboTech
//
//  Created by sq on 7/17/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Kingfisher

class PaymentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accountImageView : UIImageView!
    @IBOutlet weak var accountNameLabel : UILabel!
    @IBOutlet weak var accountNumberLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func setData(account : PaymentAccount){
        self.accountNameLabel.text = "account name".localized + " : " + account.accountName
        self.accountNumberLabel.text = "account number".localized + " : " + account.accountNumber
        let url = URL(string: account.imageUrl)
        accountImageView.kf.setImage(with: url, placeholder: UIImage(named: account.imageUrl))
    }
    
}
