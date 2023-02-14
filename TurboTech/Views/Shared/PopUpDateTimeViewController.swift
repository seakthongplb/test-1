//
//  PopUpDateTimeViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PopUpDateTimeViewController: UIViewController {

    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var alertView : UIView!
    @IBOutlet weak var tabGesture : UIGestureRecognizer!
    
    var currentDate : Date?
    var delegate : DateTimePopUpDelegate?
    
    var isDateTime : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        view.addGestureRecognizer(tabGesture)
        dateTimePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            dateTimePicker.preferredDatePickerStyle = .wheels
        }
        self.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
    }

    @IBAction func donePressed(_ sender: Any) {
//        print("POP UP DATE : ", dateTimePicker.date)
        delegate?.responsePickDate(dateTimePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dateTimePicker.date = currentDate ?? Date()
    }
    
    @IBAction func pickerGesturePressed(_ sender: UIGestureRecognizer) {
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

extension PopUpDateTimeViewController : UIDocumentPickerDelegate {
    
}
