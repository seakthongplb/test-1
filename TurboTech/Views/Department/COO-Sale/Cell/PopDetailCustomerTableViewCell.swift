//
//  PopDetailCustomerTableViewCell.swift
//  TurboTech
//
//  Created by wo on 9/9/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PopDetailCustomerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var cifLabel : UILabel!
    @IBOutlet weak var accountNameLabel : UILabel!
    @IBOutlet weak var coreLabel : UILabel!
    @IBOutlet weak var cifDataLabel : UILabel!
    @IBOutlet weak var accountNameDataLabel : UILabel!
    @IBOutlet weak var coreDataLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        self.setup()
    }
    
    private func setup(){
        self.containerView.roundCorners(corners: UIRectCorner([.allCorners]), radius: SIZE.RADIUS_CARD)
        self.containerView.layer.borderWidth = 0.5
        self.containerView.layer.borderColor = UIColor.gray.cgColor
        self.cifLabel.text = "cif".localized
        self.accountNameLabel.text = "account name".localized
        self.coreLabel.text = "core".localized
    }
    
    func setData(_ data : PopCustomer){
        self.cifDataLabel.text = data.cif
        self.accountNameDataLabel.text = data.accountName
        self.coreDataLabel.text = data.core
    }
    
}
