//
//  CRMShortRegisterViewController.swift
//  TurboTech
//
//  Created by sq on 7/6/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class CRMShortRegisterViewController: UIViewController {

    @IBOutlet weak var leadInformationLabel : UILabel!
    @IBOutlet weak var  firstnameTextField : UITextField!
    @IBOutlet weak var lastnameTextField : UITextField!
    @IBOutlet weak var mobileTextField : UITextField!
    @IBOutlet weak var  saveButton : UIButton!
    private var activeTextField = UITextField()
    private var crmViewModel = CRMViewModel()
    var onDoneBlock : ((_ status : Bool)->())?
    var addedStatus : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let onDoneBlock = self.onDoneBlock {
            onDoneBlock(addedStatus)
        }
    }
    
    private func setup(){
        localized()
        addDoneButtonOnKeyboard()
        firstnameTextField.customizeRegister()
        lastnameTextField.customizeRegister()
        mobileTextField.customizeRegister()
        
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        mobileTextField.delegate = self
    }
    
    private func localized(){
        leadInformationLabel.text = "lead information".localized
        self.saveButton.setTitle("save".localized, for: .normal)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let firstname = firstnameTextField.text, let lastname = lastnameTextField.text, let phone = mobileTextField.text else { return }
        DispatchQueue.main.async {
            if let username = AppDelegate.user?.userName {
                self.crmViewModel.postCreateLeadShortForm(username: username, firstName: firstname, lastName: lastname, phoneNumber: phone) { (message) in
                    self.showAndDismissAlert(title: message, message: nil, style: .alert, second: 1.0)
                    self.addedStatus = true
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    

}

extension CRMShortRegisterViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 10
        if let nextResponder = textField.superview?.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension CRMShortRegisterViewController {
    @objc func donePicker(_ sender : UIBarButtonItem){
        activeTextField.resignFirstResponder()
    }
    
    func addDoneButtonOnKeyboard() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = COLOR.BLUE
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        firstnameTextField.inputAccessoryView = toolBar
        lastnameTextField.inputAccessoryView = toolBar
        mobileTextField.inputAccessoryView = toolBar
        
        firstnameTextField.autocorrectionType = .no
        lastnameTextField.autocorrectionType = .no
        mobileTextField.autocorrectionType = .no

    }
    
//    @objc func keyboardWillShow(_ notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            var contentInset : UIEdgeInsets = self.scrollView.contentInset
//            contentInset.bottom = keyboardSize.size.height + 16
//            scrollView.contentInset = contentInset
//        }
//    }
//
//    @objc func keyboardWillHide(_ notification: NSNotification) {
//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        scrollView.contentInset = contentInset
//    }
}
