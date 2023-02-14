//
//  FAQsTableViewHeader.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class FAQsTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var questionTextView: UITextView!
    
    func setData(question : String){
        questionTextView.text = question
        setView()
    }
    
    func setView(){
        containerView.layer.cornerRadius = SIZE.RADIUS
    }
}
