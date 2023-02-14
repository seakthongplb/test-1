//
//  TicketHelpDeskInsertionView.swift
//  TurboTech
//
//  Created by sq on 7/15/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class TicketHelpDeskInsertionView: UIView {
    
    public var target : UIViewController!
    public var isCreate : Bool = true
    public var ticket : TicketNotification?
    public var dept : String?
    
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var subjectTextField : UITextField!
    @IBOutlet weak var descriptionTextView : UITextView!
    @IBOutlet weak var organizationNameTextField : UITextField!
    @IBOutlet weak var contactNameTextField : UITextField!
    @IBOutlet weak var assignToDepartmentTextField : UITextField!
    @IBOutlet weak var assignToStaffTextField : UITextField!
    @IBOutlet weak var statusTextField : UITextField!
    @IBOutlet weak var severityTextField : UITextField!
    @IBOutlet weak var categoryTextField : UITextField!
    
    @IBOutlet weak var assignToDeptStackView : UIStackView!
    @IBOutlet weak var assignToAndStatusStackView : UIStackView!
    
    private var activeTextField : UITextField!
    private var picker = UIPickerView()
    private var ticketViewModel = TicketViewModel()
    
    private var serverityList = [TicketSeverity]()
    private var deptList = [TicketUser]()
    private var categoryList = [TicketCategory]()
    private var contactList = [TicketContact]()
    private var organizationList = [TicketOrganization]()
    private var userList = [TicketUser]()
    private var departmentList = [TicketStatus]()
    private var statusList = [TicketStatus]()
    
    private var activePickerData = [PickerData]()
    private var contactIndex : Int?
    private var organizationIndex : Int?
    private var serverityIndex : Int?
    private var categoryIndex : Int?
    private var departmentIndex : Int?
    private var assignToStaffIndex : Int?
    private var statusIndex : Int?
    
//    var ticketCreator : TicketCreator = .other
    
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
    
    override func layoutSubviews() {
        setup()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("TicketHelpDeskInsertionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setup()
        fetchData()
    }
    
    func setup(){
        if self.ticket != nil {
            isCreate = false
        }
        picker.delegate = self
        picker.dataSource = self
        subjectTextField.delegate = self
        organizationNameTextField.delegate = self
        contactNameTextField.delegate = self
        assignToDepartmentTextField.delegate = self
        assignToStaffTextField.delegate = self
        statusTextField.delegate = self
        severityTextField.delegate = self
        categoryTextField.delegate = self
        addDoneButtonOnKeyboard()
        setData()
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        descriptionTextView.layer.borderWidth = 0.5
//        descriptionTextView.clipsToBounds = true
        
    }
    
    func setData(){
        if !isCreate { // Edit Ticket
            self.statusTextField.isHidden = false
            if let ticket = ticket {
                subjectTextField.text = ticket.subject
                descriptionTextView.text = ticket.description
                
                contactNameTextField.text = ticket.contact_name
                contactIndex = contactList.firstIndex(where: {$0.name == ticket.contact_name})
                
                organizationNameTextField.text = ticket.organization_name
                organizationIndex = organizationList.firstIndex(where: {$0.name == ticket.organization_name})
                
                severityTextField.text = ticket.severity
                serverityIndex = serverityList.firstIndex(where: {$0.name == ticket.severity})
                
                categoryTextField.text = ticket.category
                categoryIndex = categoryList.firstIndex(where: {$0.name == ticket.category})
                
                assignToDeptStackView.isHidden = true
                assignToAndStatusStackView.isHidden = false
                assignToStaffTextField.text = ticket.assigned_to
                assignToStaffIndex = userList.firstIndex(where: {$0.name == ticket.assigned_to})
                statusTextField.isHidden = false
                statusTextField.text = ticket.status
                statusIndex = statusList.firstIndex(where: {$0.name == ticket.status})
            } else {
                // EDIT TICKET ERROR #001 ELSE
            }
        }
    }
    
    func fetchData() {
        DispatchQueue.main.async {
            guard let user = AppDelegate.user else { return }
            
            if (user.position == .helpDeskAndSupport || user.department == .TOP) {
                self.assignToAndStatusStackView.isHidden = self.isCreate
                self.deptList.append(TicketUser(id: 105, name: "ITD"))//id user= Chim Bunthoeurn
                self.deptList.append(TicketUser(id: 18, name: "OPD"))//id user=   San Makara
                self.deptList.append(TicketUser(id: 28, name: "FND"))//id user= Heng Dany
                self.deptList.append(TicketUser(id: 20, name: "BSD"))//id user= Roeurng Vuthy
                if let dept = self.dept {
                    self.ticketViewModel.fetchUser(department: dept == "TOP" ? "Top%20Managment" : dept) { (userList) in
                        self.userList = userList
                        self.setData()
                    }
                }
            } else {
                self.assignToDeptStackView.isHidden = true
                switch user.position {
                case .accountManager, .financeManager, .salesAdmin, .saleAdmin, .salesManagerCRM, .keyAccountManager, .keyAccountOfficer, .saleManager, .stockManager, .supportManager, .technicalManager :
                    self.ticketViewModel.fetchUser(department: "\(user.department)") { (list) in
                        self.userList = list
                    }
                default:
                    self.assignToAndStatusStackView.isHidden = true
                }
            }
            
            self.ticketViewModel.fetchOrganization { (list) in
                self.organizationList = list
            }
            
            self.ticketViewModel.fetchContact { (list) in
                self.contactList = list
            }
            
            self.ticketViewModel.fetchServerity { (list) in
                self.serverityList = list
            }
            
            self.ticketViewModel.fetchCategory { (list) in
                self.categoryList = list
            }
            
            self.ticketViewModel.fetchStatus { (list) in
                self.statusList = list
            }
        }
    }
    
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
        
        let textFields = [
            subjectTextField,
            organizationNameTextField,
            contactNameTextField,
            assignToDepartmentTextField,
            assignToStaffTextField,
            statusTextField,
            severityTextField,
            categoryTextField
        ]

        setupMulipleTextField(textFields, tag: 10, picker: picker, toolBar: toolBar, dropDownIndex: 1,2,3,4,5,6,7)
    }
}


extension TicketHelpDeskInsertionView : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        switch textField {
            case severityTextField, categoryTextField, assignToDepartmentTextField, assignToStaffTextField, statusTextField :
                setDataPicker()
            case contactNameTextField :
                textField.resignFirstResponder()
                let vc = target.storyboard?.instantiateViewController(withIdentifier: "PackageCRMViewControllerID") as! PackageCRMViewController
                vc.modalPresentationStyle = .overCurrentContext
                if let selected = contactIndex {
                    vc.oldSelected = selected
                }
                vc.popUpSearchList = self.contactList
                vc.onDoneBlock = { id, name in
                    self.contactIndex = id
                    self.contactNameTextField.text = name
                }
                target.present(vc, animated: true, completion: nil)
            case organizationNameTextField :
                textField.resignFirstResponder()
                let vc = target.storyboard?.instantiateViewController(withIdentifier: "PackageCRMViewControllerID") as! PackageCRMViewController
                vc.modalPresentationStyle = .overCurrentContext
                if let selected = organizationIndex {
                    vc.oldSelected = selected
                }
                vc.popUpSearchList = self.organizationList
                vc.onDoneBlock = { id, name in
                    self.organizationIndex = id
                    textField.text = name
                }
                target.present(vc, animated: true, completion: nil)
            default:
                break
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
            case
            organizationNameTextField,
            contactNameTextField,
            assignToDepartmentTextField,
            assignToStaffTextField,
            statusTextField,
            severityTextField,
            categoryTextField:
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
    
    func getTicket()->TicketNotification? {
        
        let red = UIColor.red.cgColor
        let gray = UIColor.gray.cgColor
        var status : Bool = true
        
        subjectTextField.layer.borderColor = gray
        contactNameTextField.layer.borderColor = gray
        organizationNameTextField.layer.borderColor = gray
        severityTextField.layer.borderColor = gray
        categoryTextField.layer.borderColor = gray
        descriptionTextView.layer.borderColor = gray
        assignToDepartmentTextField.layer.borderColor = gray
        assignToStaffTextField.layer.borderColor = gray
        
        let subject = subjectTextField.text
        let severity = severityTextField.text
        let category = categoryTextField.text
        let descripitonI = descriptionTextView.text
        let dept = assignToDepartmentTextField.text
        let assignToStaff = assignToStaffTextField.text
        var assignTo = self.ticket != nil ? self.ticket!.assigned_to : ""
        
        if subject == nil || subject == "" {
            subjectTextField.layer.borderColor = red
            status = false
        }
        if severity == nil || severity == "" {
            severityTextField.layer.borderColor = red
            status = false
        }
        if category == nil || category == "" {
            categoryTextField.layer.borderColor = red
            status = false
        }
        
        if !assignToDeptStackView.isHidden {
            if dept == nil || dept == "" {
                assignToDepartmentTextField.layer.borderColor = red
                status = false
            } else {
                if let id = self.deptList.first(where: {$0.name == dept})?.id {
                    assignTo = "\(id)"
                }
            }
        }
        
        if !assignToAndStatusStackView.isHidden {
            if assignToStaff == nil || assignToStaff == "" {
                assignToStaffTextField.layer.borderColor = red
                status = false
            } else {
                if let id = self.assignToStaffIndex{
                    if self.userList.count > id {
                        assignTo = "\(self.userList[id].id)"
                    }
                }
            }
        }
        
//        print("Status : ", status, assignTo)
        return
            status ? (
                self.isCreate ?
                    TicketNotification(
                        subject: subject ?? "",
                        decription: descripitonI ?? "",
                        contactName: "\(contactIndex ?? 0)",
                        organization: "\(organizationIndex ?? 0)",
                        severity: severity ?? "",
                        category: category ?? "",
                        assignedTo: assignTo)
                    : TicketNotification(
                        ticketNumber : self.ticket?.ticket_id ?? "",
                        subject: subject ?? "",
                        decription: descripitonI ?? "",
                        contactName: "\(contactIndex ?? 0)",
                        organization: "\(organizationIndex ?? 0)",
                        severity: severity ?? "",
                        category: category ?? "",
                        assignedTo: assignTo,
                        status: self.statusTextField.text ?? "Open")
                )
                : nil
    }
}

extension TicketHelpDeskInsertionView : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func setDataPicker(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = COLOR.RED
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        activeTextField.inputView = picker
        activeTextField.inputAccessoryView = toolBar
        var pickId : Int = 0
        switch self.activeTextField {
            case severityTextField :
                pickId = serverityIndex ?? 0
                self.activePickerData = self.serverityList
            case categoryTextField :
                pickId = categoryIndex ?? 0
                self.activePickerData = self.categoryList
            case assignToDepartmentTextField :
                pickId = departmentIndex ?? 0
                self.activePickerData = self.deptList
            case assignToStaffTextField :
                pickId = assignToStaffIndex ?? 0
                self.activePickerData = self.userList
            case statusTextField :
                pickId = statusIndex ?? 0
                self.activePickerData = self.statusList
            default :
                return
        }
        
        self.picker.reloadAllComponents()
        self.picker.selectRow(pickId, inComponent: 0, animated: true)
        self.pickerView(self.picker, didSelectRow: pickId, inComponent: 0)
    }
    
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
        if activePickerData.count == 0{
            self.fetchData()
            return
        }
        activeTextField.text = activePickerData[row].name
        switch self.activeTextField {
            case severityTextField :
                serverityIndex = row
            case categoryTextField :
                categoryIndex = row
            case assignToDepartmentTextField :
                departmentIndex = row
            case assignToStaffTextField :
                assignToStaffIndex = row
            case statusTextField :
                statusIndex = row
            default :
                return
        }
    }
    
}
