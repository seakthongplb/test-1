//
//  SelectBetweenDateViewController.swift
//  TurboTech
//
//  Created by wo on 9/28/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class SelectBetweenDateViewController: UIViewController {
    
    @IBOutlet weak var alertView : UIView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var startDateLabel : UILabel!
    @IBOutlet weak var toDateLabel : UILabel!
    @IBOutlet weak var startDateTextField : UITextField!
    @IBOutlet weak var toDateTextField : UITextField!
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var confrimButton : UIButton!
    
    var activeTextField = UITextField()
    
    var onDoneBlock : ((_ start : String, _ to : String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = COLOR.BLUE
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(timePickerAction(_:)), for: .valueChanged)
        self.startDateTextField.inputView = datePicker
        self.startDateTextField.delegate = self
        self.startDateTextField.inputAccessoryView = toolBar
        self.toDateTextField.inputView = datePicker
        self.toDateTextField.delegate = self
        self.toDateTextField.inputAccessoryView = toolBar
    }
    
    @objc func donePicker(_ sender : UIBarButtonItem){
        activeTextField.resignFirstResponder()
    }
    
    @objc func timePickerAction(_ sender : UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: sender.date)
        switch self.activeTextField {
            case self.startDateTextField :
                if let toDate = self.toDateTextField.text {
                    if toDate == "" {
                        self.startDateTextField.text = strDate
                    } else {
                        guard let sDate = dateFormatter.date(from: strDate), let tDate = dateFormatter.date(from: toDate) else {
                            return
                        }
                        if sDate >= tDate {
                            self.startDateTextField.text = dateFormatter.string(from: (tDate.addingTimeInterval(-24*60*60)))
                        } else {
                            self.startDateTextField.text = strDate
                        }
                        
                    }
                }
            case self.toDateTextField :
                if let startDate = self.startDateTextField.text {
                    if startDate == "" {
                        self.toDateTextField.text = strDate
                    } else {
                        guard let tDate = dateFormatter.date(from: strDate), let sDate = dateFormatter.date(from: startDate) else {
                            return
                        }
                        if sDate >= tDate {
                            self.startDateTextField.text = dateFormatter.string(from: (tDate.addingTimeInterval(-24*60*60)))
                        }
                        self.toDateTextField.text = strDate
                        
                    }
                }
            default :
                print("DEF")
        }
    }
    
    @IBAction func buttonPress(_ sender : UIButton){
        switch sender {
        case self.cancelButton :
            self.dismiss(animated: true, completion: nil)
        case self.confrimButton :
            guard let onDone = self.onDoneBlock, let sD = self.startDateTextField.text, let tD = self.toDateTextField.text else { return }
            print(sD, tD)
            onDone(sD, tD)
            self.dismiss(animated: true, completion: nil)
        default:
            print("DEF")
        }
    }
    
}

extension SelectBetweenDateViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
}
