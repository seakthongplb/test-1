//
//  DeviceTableViewCell.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Kingfisher

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var devicePriceLabel: UILabel!
    @IBOutlet weak var deviceImageVIew : UIImageView!
    @IBOutlet weak var imageContainerView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setView(){
        containerView.layer.cornerRadius = SIZE.RADIUS_CARD
    }
    
    func setData(device : Device) {
        self.deviceNameLabel.text = device.name
        self.devicePriceLabel.text = "\(device.price)"
        print(device.imageUrl)
        let url = URL(string: device.imageUrl)
        self.deviceImageVIew.kf.setImage(with: url, placeholder: UIImage(named: "no_archive"))
    }
    
}
