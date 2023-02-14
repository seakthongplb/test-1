//
//  TableViewHelper.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import FittedSheets

extension UITableView {

    func setEmptyTableView(_ image: UIImage?, _ message: String?) {
        
        // MARK: Message Image
        let rect = CGRect(x: 0, y: 0, width: self.bounds.size.width,
                          height: self.bounds.size.height - 200)
        let imageMessage = UIImageView(frame: rect)
        
        // MARK: Message Label
        let messageLabel = UILabel()
        messageLabel.frame = CGRect(x: 0,
                                    y: imageMessage.bounds.size.height,
                                    width: self.bounds.size.width,
                                    height: 100)
        
        messageLabel.text = message
        messageLabel.textAlignment = .center
        
        imageMessage.image = image
        imageMessage.contentMode = .scaleAspectFit
        messageLabel.numberOfLines = 2
        messageLabel.font = UIFont(name: "Quicksand-bold", size: 20)
        messageLabel.textColor = COLOR.BLUE
        
        if DeviceTraitStatus.current == .wRhR {
             messageLabel.font = UIFont(name: "Quicksand-bold", size: 32)
        }
        let backGroundView = UIView()
        backgroundView?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        
        backGroundView.addSubview(imageMessage)
        backGroundView.addSubview(messageLabel)
        
        self.backgroundView = backGroundView
       
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
