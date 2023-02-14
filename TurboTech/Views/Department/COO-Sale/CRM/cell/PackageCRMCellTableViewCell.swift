//
//  PackageCRMCellTableViewCell.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PackageCRMCellTableViewCell: UITableViewCell {

    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func isSelected(_ selected : Bool){
        selected ? clearSelected() : setSelected()
    }
    
    func setSelected(){
        radioButton.setImage(UIImage(named: "circle"), for: .normal)
    }
    
    func clearSelected(){
        radioButton.setImage(UIImage(named: "check-circle"), for: .normal)
    }
    
    func setPackage(package : PopUpSearchProtocol) {
        packageLabel.text = package.name
        self.tag = package.id
    }
    
}
