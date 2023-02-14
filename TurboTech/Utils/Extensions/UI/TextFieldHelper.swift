//
//  TextFieldHelper.swift
//  TurboTech
//
//  Created by sq on 6/26/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

extension UITextField {
    func customizeRegister(color : CGColor, radius : CGFloat){
        self.layer.masksToBounds = true
        self.layer.borderColor = color
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = radius
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftViewMode = .always
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.font : UIFont.boldSystemFont(ofSize: 14.0)])
    }
    
    func customizeRegister(){
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = self.frame.height / 2
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftViewMode = .always
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder?.localized ?? "", attributes: [.font : UIFont.boldSystemFont(ofSize: 14.0)])
    }
    
    func setDropDownImage(){
        let b : CGFloat = 44.0
        let bounds = CGRect(x: 0, y: 0, width: b, height: b)
        let s : CGFloat = 12.0
        let h : CGFloat = b - 2.75 * s
        let y = (b - h)/2
        let imageBounds = CGRect(x: s, y: y, width: b - 2*s , height: h)
        let image = UIImage(named: "chevron-down")
        let imageView = UIImageView(frame: imageBounds)
        imageView.image = image
        self.rightView = UIView(frame: bounds)
        rightView?.tintColor = .gray
        self.rightView?.addSubview(imageView)
        self.rightViewMode = .always
    }
}

