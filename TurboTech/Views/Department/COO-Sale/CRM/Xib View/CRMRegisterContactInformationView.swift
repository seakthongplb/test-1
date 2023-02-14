//
//  CRMRegisterContactInformationView.swift
//  TurboTech
//
//  Created by sq on 6/30/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class CRMRegisterContactInformationView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet var firstnameTextField : UITextField!
    @IBOutlet var lastnameTextField : UITextField!
    @IBOutlet var phoneNumberTextField : UITextField!
    @IBOutlet var contactEmailTextField : UITextField!
    @IBOutlet var positionTextField : UITextField!
    
    private var activeTextField = UITextField()
    var crmContactInformation : CRMContactInformation?
    
    override init(frame: CGRect) {
//        Using CustomView in Code
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        Using customView in IB
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CRMRegisterContactInformationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setup()
        fetchData()
    }
    
    private func setup(){
        localized()
        self.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        firstnameTextField.customizeRegister()
        lastnameTextField.customizeRegister()
        phoneNumberTextField.customizeRegister()
        contactEmailTextField.customizeRegister()
        positionTextField.customizeRegister()
        
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        phoneNumberTextField.delegate = self
        contactEmailTextField.delegate = self
        positionTextField.delegate = self
    }
    
    func localized(){
        titleLabel.text = "contact information".localized
    }
    
    func fetchData(){
        DispatchQueue.main.async {
            if let crmContactInformation = self.crmContactInformation {
//                print("WORK Contact Info")
                self.setOldData(data: crmContactInformation)
            } else {
//                print("Sorry bro")
            }
        }
    }
    
    func setOldData(data : CRMContactInformation){
        firstnameTextField.text = data.firstName
        lastnameTextField.text = data.lastName
        phoneNumberTextField.text = data.phoneNumber
        contactEmailTextField.text = data.contactEmail
        positionTextField.text = data.position
    }
}

extension CRMRegisterContactInformationView : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
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

extension CRMRegisterContactInformationView {
    
    @objc func donePicker(_ sender : UIBarButtonItem){
        activeTextField.resignFirstResponder()
    }
    
    func addDoneButtonOnKeyboard() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = COLOR.BLUE
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "done".localized, style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        firstnameTextField.inputAccessoryView = toolBar
        lastnameTextField.inputAccessoryView = toolBar
        phoneNumberTextField.inputAccessoryView = toolBar
        contactEmailTextField.inputAccessoryView = toolBar
        positionTextField.inputAccessoryView = toolBar
        
        firstnameTextField.autocorrectionType = .no
        lastnameTextField.autocorrectionType = .no
        phoneNumberTextField.autocorrectionType = .no
        contactEmailTextField.autocorrectionType = .no
        positionTextField.autocorrectionType = .no

    }
    
    func doneButtonAction() {
        firstnameTextField.resignFirstResponder()
        lastnameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        contactEmailTextField.resignFirstResponder()
        positionTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset : UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardSize.size.height + 16
            scrollView.contentInset = contentInset
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func isValidData() -> (CRMContactInformation?){
        let red = UIColor.red.cgColor
        let gray = UIColor.gray.cgColor
        var status : Bool = true

        let firstname = firstnameTextField.text
        let lastname = lastnameTextField.text
        let phoneNumber = phoneNumberTextField.text
        let email = contactEmailTextField.text
        let position = positionTextField.text

        firstnameTextField.layer.borderColor = gray
        lastnameTextField.layer.borderColor = gray
        phoneNumberTextField.layer.borderColor = gray
        contactEmailTextField.layer.borderColor = gray
        positionTextField.layer.borderColor = gray
        
        if crmContactInformation == nil {

            if firstname == nil || firstname == "" {
                firstnameTextField.layer.borderColor = red
                status = false
            }

            if lastname == nil || lastname == "" {
                lastnameTextField.layer.borderColor = red
                status = false
            }

            if phoneNumber == nil || phoneNumber == "" || !Validaton.shared.validaPhoneNumber(phoneNumber: phoneNumber ?? "") {
                phoneNumberTextField.layer.borderColor = red
                status = false
            }

            if email == nil || email == "" || !Validaton.shared.validateEmailId(emailID: email ?? ""){
                contactEmailTextField.layer.borderColor = red
                status = false
            }

            if position == nil || position == "" {
                positionTextField.layer.borderColor = red
                status = false
            }
        } else {
            status = true
        }
        
        return status ? CRMContactInformation(firstName: firstname, lastName: lastname, phoneNumber: phoneNumber, contactEmail: email, position: position) : nil
    }
}

