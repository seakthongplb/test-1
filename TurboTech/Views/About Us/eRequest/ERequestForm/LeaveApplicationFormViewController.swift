//
//  LeaveApplicationFormViewController.swift
//  TurboTech
//
//  Created by Mr. iSQ on 3/19/21.
//  Copyright © 2021 TurboTech. All rights reserved.
//

import UIKit

class LeaveApplicationFormViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var navigationTitle : UILabel!
    @IBOutlet weak var leaveTypeTextField : UITextField!
    @IBOutlet weak var startDatePickerView : UIDatePicker!
    @IBOutlet weak var startDateSegnment : UISegmentedControl!
    @IBOutlet weak var toDatePickerView : UIDatePicker!
    @IBOutlet weak var toDateSegnment : UISegmentedControl!
    @IBOutlet weak var resumeDatePickerView : UIDatePicker!
    @IBOutlet weak var resumeDateSegnment : UISegmentedControl!
    @IBOutlet weak var durationLabel : UILabel!
    @IBOutlet weak var duraitonStepper : UIStepper!
    @IBOutlet weak var reasonTextView : UITextView!
    @IBOutlet weak var submitButton : UIButton!
    
    @IBOutlet weak var feedbackStackView : UIStackView!
    @IBOutlet weak var feedbackLabel : UILabel!
    @IBOutlet weak var feedbackTableView : UITableView!
    
    @IBOutlet weak var commentStackView : UIStackView!
    @IBOutlet weak var commentLabel : UILabel!
    @IBOutlet weak var commentTextView : UITextView!
    @IBOutlet weak var approveCommentButton : UIButton!
    @IBOutlet weak var pendingCommentButton : UIButton!
    @IBOutlet weak var rejectCommentButton : UIButton!
    
    let lang = LanguageManager.shared.language
    private let picker = UIPickerView()
    
    private var eRequestViewModel = ERequestViewModel()
    
    private var kindOfLeaveList = [KindOfLeave]()
    private var kindOfLeaveId : Int?
    
    private var isViewForm : Bool = false
    private var isApprovalForm : Bool = false
    private var eRequest : ERequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup(){
        self.navigationTitle.text = "Leave Application".localized
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.leaveTypeTextField.inputView = picker
        self.addDoneButtonOnKeyboard()
        self.picker.dataSource = self
        self.picker.delegate = self
        self.fetchData()
        if(isViewForm){
            self.disable()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func fetchData(){
        DispatchQueue.main.async {
            self.eRequestViewModel.fetchKindOfLeave { (data) in
                self.kindOfLeaveList = data
                self.picker.reloadAllComponents()
                if data.count > 0 {
                    self.kindOfLeaveId = data[0].id
                    self.leaveTypeTextField.text = self.lang == "en" ? data[0].nameEn : data[0].nameKh
                }
                if (self.eRequest != nil) && self.isViewForm{
                    self.registerCell()
                    self.setViewData()
                }
            }
        }
    }
    
    @IBAction func durationStepperChanged(_ sender: UIStepper) {
        self.durationLabel.text = "\(sender.value)"
    }
    
    @IBAction func submitRequest(_ sender: Any) {
        
        let formId = 3
        guard let leaveId = self.kindOfLeaveId else { return }
        guard let duration = Double(self.durationLabel.text ?? "0") else { return }
        let dateFrom = "\(self.startDatePickerView.date.toString(toFormat: FormatStringDate.yyyymdd)) \(self.startDateSegnment.selectedSegmentIndex == 0 ? "08:00:00" : "13:30")"
        let dateTo = "\(self.toDatePickerView.date.toString(toFormat: FormatStringDate.yyyymdd)) \(self.toDateSegnment.selectedSegmentIndex == 0 ? "12:00:00" : "17:30")"
        let dateResume = "\(self.resumeDatePickerView.date.toString(toFormat: FormatStringDate.yyyymdd)) \(self.resumeDateSegnment.selectedSegmentIndex == 0 ? "08:00:00" : "13:30")"
        let reason = self.reasonTextView.text
        guard let id = AppDelegate.user?.mainappId else { return }
        
        DispatchQueue.main.async {
            self.eRequestViewModel.postLeaveApplicationForm(formData: (formId: formId, kindOfLeaveId: leaveId, dateFrom: dateFrom, dateTo: dateTo, dateResume: dateResume, numberDateleave: duration, reason: reason, transferTo: nil, userId: id)) { (status) in
                if(status) {
                    self.showAndDismissAlert(title: "Success", message: nil, style: .alert, second: 1.0)
                    self.dismiss(animated: true) {
                        print("DISMISS WORK")
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.showAndDismissAlert(title: "Try Again", message: nil, style: .alert, second: 1.0)
                }
            }
        }
    }
    
    @IBAction func submitApprovalClick(_ button : UIButton){
        
        let comment = self.commentTextView.text
        guard let eRequestId = self.eRequest?.id, let id = AppDelegate.user?.mainappId, let status = button.titleLabel?.text?.lowercased() else {
            self.showAndDismissAlert(title: "Try Again", message: nil, style: .alert, second: 1.0)
            return
        }
        DispatchQueue.main.async {
            self.eRequestViewModel.postERequestDetail(data: (eRequestId: eRequestId, comment: comment, status: status, userId: id)) { (status) in
                if(status) {
                    self.showAndDismissAlert(title: "Success", message: nil, style: .alert, second: 1.0)
                    self.dismiss(animated: true) {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.showAndDismissAlert(title: "Try Again", message: nil, style: .alert, second: 1.0)
                }
            }
        }
    }
    
    private func registerCell(){
        self.feedbackTableView.dataSource = self
        self.feedbackTableView.register(UINib(nibName: "ERequestDetailFeedbackTableViewCell", bundle: nil), forCellReuseIdentifier: "ERequestDetailFeedbackTableViewCellID")
    }
    
    func readView(eRequest : ERequest, isApprovalForm : Bool = false){
        self.isViewForm = true
        self.eRequest = eRequest
        self.isApprovalForm = isApprovalForm
    }
    
    private func disable(){
        let status = false
        self.leaveTypeTextField.isEnabled = status
        self.startDatePickerView.isEnabled = status
        self.startDateSegnment.isEnabled = status
        self.toDatePickerView.isEnabled = status
        self.toDateSegnment.isEnabled = status
        self.resumeDatePickerView.isEnabled = status
        self.resumeDateSegnment.isEnabled = status
        self.duraitonStepper.isEnabled = status
        self.reasonTextView.isEditable = status
        self.reasonTextView.isSelectable = status
        self.submitButton.isHidden = !status
        self.feedbackStackView.isHidden = status
        if self.isApprovalForm {
            self.commentStackView.isHidden = status
        }
    }
    
    private func setViewData(){
        guard let er = self.eRequest else {
//            DISMISS SCREEN
            return
        }
        
        let lf = er.formDetail as! LeaveApplicationForm
        
        if let sd = lf.dateFrom, let td = lf.dateTo, let rd = lf.dateResume {
            self.startDatePickerView.date = sd
            self.toDatePickerView.date = td
            self.resumeDatePickerView.date = rd
            
            let calendar = Calendar.current
            
            self.startDateSegnment.selectedSegmentIndex = calendar.component(.hour, from: sd) == 8 ? 0 : 1
            self.toDateSegnment.selectedSegmentIndex = calendar.component(.hour, from: sd) == 12 ? 0 : 1
            self.resumeDateSegnment.selectedSegmentIndex = calendar.component(.hour, from: sd) == 8 ? 0 : 1
        }
        
        if let lttf = kindOfLeaveList.first(where: {$0.id == lf.kindOfLeaveID}) {
            self.leaveTypeTextField.text = lang == "en" ? lttf.nameEn : lttf.nameKh
        }
        
        self.durationLabel.text = lf.numberDateLeave
        self.reasonTextView.text = lf.reason
        
//        RELOAD TABLE
        self.feedbackTableView.reloadData()
    }
    
}

extension LeaveApplicationFormViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.kindOfLeaveList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lang == "en" ? self.kindOfLeaveList[row].nameEn : self.kindOfLeaveList[row].nameKh
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.leaveTypeTextField.text = lang == "en" ? self.kindOfLeaveList[row].nameEn : self.kindOfLeaveList[row].nameKh
        self.kindOfLeaveId = self.kindOfLeaveList[row].id
    }
    
}

extension LeaveApplicationFormViewController : UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) { }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.leaveTypeTextField :
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

extension LeaveApplicationFormViewController {
    
    @objc func donePicker(_ sender : UIBarButtonItem){
        leaveTypeTextField.resignFirstResponder()
        reasonTextView.resignFirstResponder()
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
        self.leaveTypeTextField.inputAccessoryView = toolBar
        self.reasonTextView.inputAccessoryView = toolBar
        
        self.leaveTypeTextField.autocorrectionType = .no
        self.reasonTextView.autocorrectionType = .no


    }
    
    func doneButtonAction() {
        self.leaveTypeTextField.resignFirstResponder()
        self.reasonTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset : UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardSize.size.height + 16
            self.scrollView.contentInset = contentInset
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }

    
}

extension LeaveApplicationFormViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let erd = eRequest?.eRequestDetail else { return 0}
        return erd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERequestDetailFeedbackTableViewCellID", for: indexPath) as! ERequestDetailFeedbackTableViewCell
        guard let erd = eRequest?.eRequestDetail else { return UITableViewCell() }
        cell.setData(erd: erd[indexPath.row])
        return cell
    }
    
    
}
