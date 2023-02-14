//
//  CRMRegisterFirstStepView.swift
//  TurboTech
//
//  Created by sq on 6/30/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class CRMRegisterFirstStepView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var companyNameTextField : UITextField!
    @IBOutlet weak var customerNameTextField : UITextField!
    @IBOutlet weak var phoneNumberTextField : UITextField!
    @IBOutlet weak var vateTypeTextField : UITextField!
    @IBOutlet weak var customerTypeTextField : UITextField!
    @IBOutlet weak var customerRateTextField : UITextField!
    @IBOutlet weak var industryTextField : UITextField!
    @IBOutlet weak var assignedToTextField : UITextField!
    @IBOutlet weak var branchTextField: UITextField!
    
    private let picker = UIPickerView()
    private var activeTextField = UITextField()
    var crmViewModel = CRMViewModel()
    var crmLeadInformation : CRMLeadInformation?
    
    var activePickerData = [CRMPickerData]()
    var vatTypeList = [CRMPickerData]()
    var customerTypeList = [CRMPickerData]()
    var customerRateList = [CRMPickerData]()
    var inductryList = [CRMPickerData]()
    var assignedToList = [CRMPickerData]()
    var branchList = [CRMPickerData]()
    var vatTypeIndex : Int?
    var customerTypeIndex : Int?
    var customerRateIndex : Int?
    var industryIndex : Int?
    var assignedToIndex : Int?
    var branchIndex : Int?
    
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
        Bundle.main.loadNibNamed("CRMRegisterFirstStepView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setup()
        fetchData()
    }
    
    private func setup(){
        self.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        localized()
        
        companyNameTextField.customizeRegister()
        customerNameTextField.customizeRegister()
        phoneNumberTextField.customizeRegister()
        vateTypeTextField.customizeRegister()
        customerTypeTextField.customizeRegister()
        customerRateTextField.customizeRegister()
        industryTextField.customizeRegister()
        assignedToTextField.customizeRegister()
        branchTextField.customizeRegister()
        
        vateTypeTextField.setDropDownImage()
        customerTypeTextField.setDropDownImage()
        customerRateTextField.setDropDownImage()
        industryTextField.setDropDownImage()
        assignedToTextField.setDropDownImage()
        branchTextField.setDropDownImage()
        
        vateTypeTextField.inputView = picker
        customerTypeTextField.inputView = picker
        customerRateTextField.inputView = picker
        industryTextField.inputView = picker
        assignedToTextField.inputView = picker
        branchTextField.inputView = picker
        
        picker.dataSource = self
        picker.delegate = self
        
        companyNameTextField.delegate = self
        customerNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        vateTypeTextField.delegate = self
        customerTypeTextField.delegate = self
        customerRateTextField.delegate = self
        industryTextField.delegate = self
        assignedToTextField.delegate = self
        branchTextField.delegate = self
    }
    
    func localized(){
        titleLabel.text = "lead information".localized
    }
    
    func fetchData(){
        DispatchQueue.main.async {
            if let lead = self.crmLeadInformation {
                self.companyNameTextField.text = lead.compnayName
                self.customerNameTextField.text = lead.customerName
                self.phoneNumberTextField.text = lead.primaryPhone
                
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .vatType) { (list) in
                    self.vatTypeList = list
                    if let id = list.firstIndex(where: {$0.name == lead.vatType}) {
                        self.vateTypeTextField.text = list[id].name
                        self.vatTypeIndex = id
                    } else {
                        self.vatTypeIndex = 0
                    }
                }
                
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .customerType) { (list) in
                    self.customerTypeList = list
                    if let id = list.firstIndex(where: {$0.name == lead.customerType}) {
                        self.customerTypeTextField.text = list[id].name
                        self.customerTypeIndex = id
                    } else {
                        self.customerTypeIndex = 0
                    }
                }
                
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .customerRate) { (list) in
                    self.customerRateList = list
                    if let id = list.firstIndex(where: {$0.name == lead.customerRate}) {
                        self.customerRateTextField.text = list[id].name
                        self.customerRateIndex = id
                    } else {
                        self.customerRateIndex = 0
                    }
                }
                
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .industry) { (list) in
                    self.inductryList = list
                    if let id = list.firstIndex(where: {$0.name == lead.industry}) {
                        self.industryTextField.text = list[id].name
                        self.industryIndex = id
                    } else {
                        self.industryIndex = 0
                    }
                }
                
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .assignedTo) { (list) in
                    self.assignedToList.removeAll()
                    if let user = AppDelegate.user {
                        self.assignedToList = [CRMPickerData(0, user.fullName)]
                    }
                    self.assignedToList.append(contentsOf: list)
                    if let id = list.firstIndex(where: {$0.name == lead.assignedTo}) {
                        self.assignedToTextField.text = list[id].name
                        self.assignedToIndex = id
                    } else {
                        self.assignedToIndex = 0
                    }
                }
                
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .branch) { (list) in
                    self.branchList = [CRMPickerData(1, "001- Phnom Penh")]
                    if let id = self.branchList.firstIndex(where: {$0.name == lead.branch}) {
                        self.branchTextField.text = self.branchList[id].name
                        self.branchIndex = id
                    } else {
                        self.branchIndex = 0
                    }
                }
                
            } else {
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .vatType) { (list) in
                    self.vatTypeList = list
                }
            
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .customerType) { (list) in
                    self.customerTypeList = list
                }
            
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .customerRate) { (list) in
                    self.customerRateList = list
                }
            
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .industry) { (list) in
                    self.inductryList = list
                }
            
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .assignedTo) { (list) in
                    self.assignedToList.removeAll()
                    self.assignedToList.append(contentsOf: list)
                }
            
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .branch) { (list) in
                    self.branchList = [CRMPickerData(1, "001- Phnom Penh")]
                }
            }
        }
    }
}

extension CRMRegisterFirstStepView : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        activePickerData.removeAll(keepingCapacity: false)
        var selectedId : Int?
        if activeTextField == vateTypeTextField {
            activePickerData = vatTypeList
            selectedId = vatTypeIndex
        } else if activeTextField == customerTypeTextField {
            activePickerData = customerTypeList
            selectedId = customerTypeIndex
        } else if activeTextField == customerRateTextField {
            activePickerData = customerRateList
            selectedId = customerRateIndex
        } else if activeTextField == industryTextField {
            activePickerData = inductryList
            selectedId = industryIndex
        } else if activeTextField == assignedToTextField {
            activePickerData = assignedToList
            selectedId = assignedToIndex
        } else if activeTextField == branchTextField {
            activePickerData = branchList
            selectedId = branchIndex
        }
        
        self.picker.reloadAllComponents()
        self.picker.selectRow(selectedId ?? 0, inComponent: 0, animated: true)
        self.pickerView(self.picker, didSelectRow: selectedId ?? 0, inComponent: 0)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case vateTypeTextField, customerTypeTextField, customerRateTextField, industryTextField, assignedToTextField, branchTextField:
            return false
        default:
            return true
        }
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

extension CRMRegisterFirstStepView : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activePickerData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var index : Int = 0
        if row < activePickerData.count {
            index = row
        }
        if activeTextField == vateTypeTextField {
            vateTypeTextField.text = activePickerData[index].name
            vatTypeIndex = index
        } else if activeTextField == customerTypeTextField {
            customerTypeTextField.text = activePickerData[index].name
            customerTypeIndex = index
        } else if activeTextField == customerRateTextField {
            customerRateTextField.text = activePickerData[index].name
            customerRateIndex = index
        } else if activeTextField == industryTextField {
            industryTextField.text = activePickerData[index].name
            industryIndex = index
        } else if activeTextField == assignedToTextField {
            assignedToTextField.text = activePickerData[index].name
            assignedToIndex = index
        } else if activeTextField == branchTextField {
            branchTextField.text = activePickerData[index].name
            branchIndex = index
        }
    }
    
}

extension CRMRegisterFirstStepView {
    
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
        companyNameTextField.inputAccessoryView = toolBar
        customerNameTextField.inputAccessoryView = toolBar
        phoneNumberTextField.inputAccessoryView = toolBar
        vateTypeTextField.inputAccessoryView = toolBar
        customerTypeTextField.inputAccessoryView = toolBar
        customerRateTextField.inputAccessoryView = toolBar
        industryTextField.inputAccessoryView = toolBar
        assignedToTextField.inputAccessoryView = toolBar
        branchTextField.inputAccessoryView = toolBar
        
        companyNameTextField.autocorrectionType = .no
        customerNameTextField.autocorrectionType = .no
        phoneNumberTextField.autocorrectionType = .no
        vateTypeTextField.autocorrectionType = .no
        customerTypeTextField.autocorrectionType = .no
        customerRateTextField.autocorrectionType = .no
        industryTextField.autocorrectionType = .no
        assignedToTextField.autocorrectionType = .no
        branchTextField.autocorrectionType = .no

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
    
    func isValidData() -> (CRMLeadInformation?){
        let red = UIColor.red.cgColor
        let gray = UIColor.gray.cgColor
        var status : Bool = true
        
        companyNameTextField.layer.borderColor = gray
        customerNameTextField.layer.borderColor = gray
        phoneNumberTextField.layer.borderColor = gray
        vateTypeTextField.layer.borderColor = gray
        customerTypeTextField.layer.borderColor = gray
        customerRateTextField.layer.borderColor = gray
        industryTextField.layer.borderColor = gray
        assignedToTextField.layer.borderColor = gray
        branchTextField.layer.borderColor = gray
        
        let companyName = companyNameTextField.text
        let customerName = customerNameTextField.text
        let phoneNumber = phoneNumberTextField.text
        let vatType = vateTypeTextField.text
        let customerType = customerTypeTextField.text
        let customerRate = customerRateTextField.text
        let industry = industryTextField.text
        let assignedTo = assignedToTextField.text
        let branch = branchTextField.text
        
        if crmLeadInformation == nil {
        
            if companyName == nil || companyName == "" {
                companyNameTextField.layer.borderColor = red
                status = false
            }
            
            if customerName == nil || customerName == "" {
                customerNameTextField.layer.borderColor = red
                status = false
            }
            
            if phoneNumber == nil || phoneNumber == "" || !Validaton.shared.validaPhoneNumber(phoneNumber: phoneNumber ?? "") {
                phoneNumberTextField.layer.borderColor = red
                status = false
            }
            
            if vatType == nil || vatType == "" {
                vateTypeTextField.layer.borderColor = red
                status = false
            }
            
            if customerType == nil || customerType == "" {
                customerTypeTextField.layer.borderColor = red
                status = false
            }
            
            if customerRate == nil || customerRate == "" {
                customerRateTextField.layer.borderColor = red
                status = false
            }
            
            if industry == nil || industry == "" {
                industryTextField.layer.borderColor = red
                status = false
            }
            
            if assignedTo == nil || assignedTo == "" {
                assignedToTextField.layer.borderColor = red
                status = false
            }
            
            if branch == nil || branch == "" {
                branchTextField.layer.borderColor = red
                status = false
            }
            
        } else {
            status = true
        }
        
        return status ? CRMLeadInformation(compnayName: companyName, customerName: customerName, primaryPhone: phoneNumber, vatType: vatType, customerType: customerType, customerRate: customerRate, industry: industry, assignedTo: "\(assignedToList[assignedToIndex!].id)", branch: branch) : nil
    }
}

