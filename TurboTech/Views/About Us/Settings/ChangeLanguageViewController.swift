//
//  ChangeLanguageViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import LGButton

class ChangeLanguageViewController: UIViewController {

    @IBOutlet var tabGesture: UITapGestureRecognizer!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var khmerButton: LGButton!
    @IBOutlet weak var englishButton: LGButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var onDoneBlock : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        localize()
    }
    
    private func localize(){
        let cur = LanguageManager.shared.language
        let circle = UIImage(named: "circle")
        let checked = UIImage(named: "check-circle")
        titleLabel.text = "choose language".localized
        khmerButton.titleString = "khmer".localized
        englishButton.titleString = "english".localized
        khmerButton.leftImageSrc = cur == "km" ? checked : circle
        englishButton.leftImageSrc = cur == "en" ? checked : circle
    }
    
    private func setup(){
        self.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
        self.view.addGestureRecognizer(tabGesture)
        titleLabel.layer.masksToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        alertView.roundCorners(corners: UIRectCorner([.allCorners]), radius: SIZE.RADIUS_CARD)
    }
    
    @IBAction func khmerChangePressed(_ sender: Any) {
        changeLanguage("km")
    }
    @IBAction func englishChangePress(_ sender: Any) {
        changeLanguage("en")
    }
    
    private func changeLanguage(_ lang : String){
        LanguageManager.shared.language = lang
        localize()
        self.dismiss(animated: true) {
            self.onDoneBlock!()
        }
    }
    
    @IBAction func viewGesturePressed(_ sender: UITapGestureRecognizer) {
        let posX = sender.location(in: view.self).x;
        let posY = sender.location(in: view.self).y;
        let minX = alertView.frame.minX;
        let maxX = alertView.frame.maxX;
        let minY = alertView.frame.minY;
        let maxY = alertView.frame.maxY;
        if ( (posX >= minX && posX <= maxX) && (posY >= minY && posY <= maxY) ) == false{
            self.dismiss(animated: true, completion: nil);
        }
    }

}
