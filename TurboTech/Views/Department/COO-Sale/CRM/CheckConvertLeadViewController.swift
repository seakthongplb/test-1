//
//  CheckConvertLeadViewController.swift
//  TurboTech
//
//  Created by sq on 7/14/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class CheckConvertLeadViewController: UIViewController {
    
    let lang = LanguageManager.shared.language
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var organizationLabel : UILabel!
    @IBOutlet weak var companyNameTextField : UITextField!
    @IBOutlet weak var customerNameTextField : UITextField!
    @IBOutlet weak var vatTypeTextField : UITextField!
    @IBOutlet weak var customerTypeTextField : UITextField!
    @IBOutlet weak var rateTypeTextField : UITextField!
    @IBOutlet weak var industryTextField : UITextField!
    @IBOutlet weak var assignToTextField : UITextField!
    @IBOutlet weak var branchTextField : UITextField!
    
    @IBOutlet weak var contactLabel : UILabel!
    @IBOutlet weak var firstNameTextField : UITextField!
    @IBOutlet weak var lastNameTextField : UITextField!
    @IBOutlet weak var phoneNumberTextField : UITextField!
    
    @IBOutlet weak var cusFirstNameLabel : UILabel!
    @IBOutlet weak var cusLastNameLabel : UILabel!
    @IBOutlet weak var cusPhoneNumberLabel : UILabel!
    @IBOutlet weak var cusOrganizationLabel : UILabel!
    @IBOutlet weak var cusCustomerNameLabel : UILabel!
    @IBOutlet weak var cusVatTypeLabel : UILabel!
    @IBOutlet weak var cusCustomerTypeLabel : UILabel!
    @IBOutlet weak var cusCustomerRateLabel : UILabel!
    @IBOutlet weak var cusIndustryLabel : UILabel!
    @IBOutlet weak var cusBranchLabel : UILabel!
    @IBOutlet weak var cusAssignToLabel : UILabel!
    
    private var activeTextField = UITextField()
    private var picker = UIPickerView()
    
    private var crmViewModel = CRMViewModel()
    private var saleViewModel = SaleViewModel()
    var leadId : String!
    var lead : Lead?
    var onDone : ((_ status : Bool)->())?
    
    private var activePickerData = [CRMPickerData]()
    private var vatTypeList = [CRMPickerData]()
    private var customerTypeList = [CRMPickerData]()
    private var rateTypeList = [CRMPickerData]()
    private var industryList = [CRMPickerData]()
    private var assignToList = [CRMPickerData]()
    private var branchList = [CRMPickerData]()
    
    private var vatTypeIndex : Int?
    private var customerTypeIndex : Int?
    private var rateTypeIndex : Int?
    private var industryIndex : Int?
    private var assignToIndex : Int?
    private var branchIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }
    
//    MARK: - Setup
    private func setup(){
        localized()
        self.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        companyNameTextField.delegate = self
        customerNameTextField.delegate = self
        vatTypeTextField.delegate = self
        customerTypeTextField.delegate = self
        rateTypeTextField.delegate = self
        industryTextField.delegate = self
        assignToTextField.delegate = self
        branchTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        picker.dataSource = self
        picker.delegate = self
    }
    
    func localized(){
        self.cusFirstNameLabel.text = "first name".localized
        self.cusLastNameLabel.text = "last name".localized
        self.cusPhoneNumberLabel.text = "phone number".localized
        self.cusOrganizationLabel.text = "organization".localized
        self.cusCustomerNameLabel.text = "customer name".localized
        self.cusVatTypeLabel.text = "vat type".localized
        self.cusCustomerTypeLabel.text = "customer type".localized
        self.cusCustomerRateLabel.text = "customer rate".localized
        self.cusIndustryLabel.text = "industry".localized
        self.cusBranchLabel.text = "branch".localized
        self.cusAssignToLabel.text = "assign to".localized
    }
    
//    MARK: - Fetch Data
    private func fetchData(){
        DispatchQueue.main.async {
            self.crmViewModel.fetchLeadByLeadId(id: self.leadId) { (message, lead) in
                self.lead = lead
                self.setOldData(lead: lead)
            }
        }
    }
    
//    MARK: - Old Data
    private func setOldData(lead : Lead?){
        let leadDetail = lead?.leadDetail
        DispatchQueue.main.async {
            self.companyNameTextField.text = leadDetail?.companyName
            self.customerNameTextField.text = leadDetail?.companyKh
            self.phoneNumberTextField.text = leadDetail?.leadPhone
            
            self.crmViewModel.fetchDropDownData(crmPickerEnum: .vatType) { (list) in
                self.vatTypeList = list
                if let id = list.firstIndex(where: {$0.name == leadDetail?.vatType}) {
                    self.vatTypeTextField.text = list[id].name
                    self.vatTypeIndex = id
                } else {
                    self.vatTypeIndex = 0
                }
            }
            
            self.crmViewModel.fetchDropDownData(crmPickerEnum: .customerType) { (list) in
                self.customerTypeList = list
                if let id = list.firstIndex(where: {$0.name == leadDetail?.cusType}) {
                    self.customerTypeTextField.text = list[id].name
                    self.customerTypeIndex = id
                } else {
                    self.customerTypeIndex = 0
                }
            }
            
            self.crmViewModel.fetchDropDownData(crmPickerEnum: .customerRate) { (list) in
                self.rateTypeList = list
                if let id = list.firstIndex(where: {$0.name == leadDetail?.cusRatingType}) {
                    self.rateTypeTextField.text = list[id].name
                    self.rateTypeIndex = id
                } else {
                    self.rateTypeIndex = 0
                }
            }
            
            self.crmViewModel.fetchDropDownData(crmPickerEnum: .industry) { (list) in
                self.industryList = list
                if let id = list.firstIndex(where: {$0.name == leadDetail?.industry}) {
                    self.industryTextField.text = list[id].name
                    self.industryIndex = id
                } else {
                    self.industryIndex = 0
                }
            }
            
            self.crmViewModel.fetchDropDownData(crmPickerEnum: .assignedTo) { (list) in
                self.assignToList.removeAll()
                self.assignToList.append(contentsOf: list)
                if let id = list.firstIndex(where: {$0.name == leadDetail?.assigTo}) {
                    self.assignToTextField.text = list[id].name
                    self.assignToIndex = id
                } else {
                    self.assignToIndex = 0
                }
            }
            
            self.crmViewModel.fetchDropDownData(crmPickerEnum: .branch) { (list) in
                // MARK: - Lead Branch (Need to Change)
                self.branchList = [CRMPickerData(1, "001- Phnom Penh")]
                if let id = self.branchList.firstIndex(where: {$0.name == leadDetail?.branch}) {
                    self.branchTextField.text = self.branchList[id].name
                    self.branchIndex = id
                } else {
                    self.branchIndex = 0
                }
            }
            
            self.firstNameTextField.text = leadDetail?.firstName
            self.lastNameTextField.text = leadDetail?.lastName
            self.phoneNumberTextField.text = leadDetail?.contactPhone
        }
    }

    @IBAction func convertPressed(_ sender : Any) {
        DispatchQueue.main.async {
            let crmViewModel = CRMViewModel()
            if let username = AppDelegate.user?.userName {
                crmViewModel.postConvertLead(username: username, status: "Qualified", leadId: self.leadId) { (message, status) in
                    let alert = UIAlertController(title: "successfully".localized, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "confirm".localized, style: .default, handler: { (_) in
                        self.dismiss(animated: true) {
                            if let onDone = self.onDone {
                                onDone(status)
                            }
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func isValidData() -> Bool{
        if companyNameTextField.text != ""
            && customerNameTextField.text != ""
            && vatTypeTextField.text != ""
            && customerTypeTextField.text != ""
            && rateTypeTextField.text != ""
            && industryTextField.text != ""
            && assignToTextField.text != ""
            && branchTextField.text != ""
            && firstNameTextField.text != ""
            && lastNameTextField.text != ""
            && phoneNumberTextField.text != "" {
            return true
        }
        return false
    }
}

//MARK: - Picker Datasource, Delegate
extension CheckConvertLeadViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        activePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        activePickerData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var index : Int = 0
        if row < activePickerData.count {
            index = row
        }
        
        switch activeTextField {
            
        case vatTypeTextField :
            vatTypeTextField.text = activePickerData[index].name
            vatTypeIndex = index
            
        case customerTypeTextField :
            customerTypeTextField.text = activePickerData[index].name
            customerTypeIndex = index
            
        case rateTypeTextField :
            rateTypeTextField.text = activePickerData[index].name
            rateTypeIndex = index
            
        case industryTextField :
            industryTextField.text = activePickerData[index].name
            industryIndex = index
            
        case assignToTextField :
            assignToTextField.text = activePickerData[index].name
            assignToIndex = index
            
        case  branchTextField :
            branchTextField.text = activePickerData[index].name
            branchIndex = index
        default :
            print("default")
        }
    }
    
}

//MARK: - TextField Delegate
extension CheckConvertLeadViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        activePickerData.removeAll(keepingCapacity: false)
        var selectedId : Int?
        switch activeTextField {
            
        case vatTypeTextField :
            activePickerData = vatTypeList
            selectedId = vatTypeIndex
            
        case customerTypeTextField :
            activePickerData = customerTypeList
            selectedId = customerTypeIndex
            
        case rateTypeTextField :
            activePickerData = rateTypeList
            selectedId = rateTypeIndex
            
        case industryTextField :
            activePickerData = industryList
            selectedId = industryIndex
            
        case assignToTextField :
            activePickerData = assignToList
            selectedId = assignToIndex
            
        case branchTextField :
            activePickerData = branchList
            selectedId = branchIndex
            
        default:
                print("default")
        }
        
        self.picker.reloadAllComponents()
        self.picker.selectRow(selectedId ?? 0, inComponent: 0, animated: false)
        self.pickerView(self.picker, didSelectRow: selectedId ?? 0, inComponent: 0)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case vatTypeTextField, customerTypeTextField, rateTypeTextField, industryTextField, assignToTextField, branchTextField :
            return false
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 10
//        print("\(textField.tag) : \(nextTag)")
        if let nextResponder = textField.superview?.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

//MARK: - Others
extension CheckConvertLeadViewController {
    
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
        
        let arr =
        [
            companyNameTextField,      customerNameTextField,    vatTypeTextField,
            customerTypeTextField,     rateTypeTextField,        industryTextField,
            assignToTextField,         branchTextField,          firstNameTextField,
            lastNameTextField,         phoneNumberTextField
        ]
        
        setupMulipleTextField( arr
            , tag: 10, picker: picker, toolBar: toolBar, dropDownIndex: 2,3,4,5,6,7)
        
    }
    
    func doneButtonAction() {
        activeTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        var contentInset : UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = 32
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}
