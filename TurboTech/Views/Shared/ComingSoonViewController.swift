//
//  ComingSoonViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class ComingSoonViewController: UIViewController {

    @IBOutlet weak var comingSoonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comingSoonLabel.text = "coming soon".localized
    }

}
