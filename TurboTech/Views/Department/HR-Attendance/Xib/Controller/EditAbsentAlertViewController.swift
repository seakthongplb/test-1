//
//  EditAbsentAlertViewController.swift
//  TurboTech
//
//  Created by wo on 9/28/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import iOSDropDown

class EditAbsentAlertViewController: UIViewController {

    @IBOutlet weak var alertView : UIView!
    @IBOutlet weak var editUsernameLabel : UILabel!
    @IBOutlet weak var typeLabel : UILabel!
    @IBOutlet weak var absentTypeTextField : DropDown!
    @IBOutlet weak var descripitonTextField : UITextField!
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var confirmButton : UIButton!
    
    @IBOutlet weak var approvedView : UIView!
    @IBOutlet weak var approvedByTextField : DropDown!
    @IBOutlet weak var chooseBetweenDateView : UIView!
    @IBOutlet weak var fromDateTextField : UITextField!
    @IBOutlet weak var toDateTextField : UITextField!
    @IBOutlet weak var selectionShiftTextField : DropDown!
    @IBOutlet weak var leaveTypeTextField : DropDown!
    
    var activeTextField = UITextField()
    var attendanceAbsent : Attendance!
    var attendanceViewModel = AttandanceViewModel()
    var shift : String!
    var remainPermission = [AttendanceRemainPermission]()
    
    var onReloadBack : ((_ isReload : Bool)->())?
    
    var typeList = ["missed scan", "others", "permission", "mission"]
    var shiftList = ["am", "pm", "full"]
    
    var attendanceApproverList = [AttendanceUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }
    
    private func fetchData(){
        DispatchQueue.main.async {
            self.attendanceViewModel.fetchRemainPermission(userId: self.attendanceAbsent.id) { (result) in
                self.remainPermission = result
                self.setLeaveType(result)
            }
            self.attendanceViewModel.fetchAttendanceUser { (data) in
                self.attendanceApproverList = data
                self.setAttendanceApprover(data)
            }
        }
    }
    
    private func setup(){
        self.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
        if let attendance = self.attendanceAbsent {
            self.setData(attendance)
        } else {
            self.dismiss(animated: true) {
                
            }
        }
        
        self.chooseBetweenDateView.isHidden = true
        self.approvedView.isHidden = true
        
        absentTypeTextField.delegate = self
        absentTypeTextField.optionArray = typeList
        absentTypeTextField.selectedIndex = 0
        absentTypeTextField.text = typeList[0]
        absentTypeTextField.selectedRowColor = .lightGray
        absentTypeTextField.didSelect { (selectedText, index, id) in
            switch index {
            case 0,1 :
                print("NORMAL")
                self.chooseBetweenDateView.isHidden = true
                self.approvedView.isHidden = true
            case 2,3 :
                print("MISSION")
                self.chooseBetweenDateView.isHidden = false
                self.approvedView.isHidden = index == 3 ? true : false
                self.fromDateTextField.isHidden = index == 3 ? false : true
                self.toDateTextField.isHidden = index == 3 ? false : true
                self.leaveTypeTextField.isHidden = index == 3 ? true : false
            default :
                print("DEF")
            }
        }
        
        selectionShiftTextField.delegate = self
        selectionShiftTextField.optionArray = shiftList
        selectionShiftTextField.selectedIndex = 0
        selectionShiftTextField.text = shiftList[0]
        selectionShiftTextField.selectedRowColor = .lightGray
        selectionShiftTextField.didSelect { (selectedText, index, id) in
            
        }
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = COLOR.BLUE
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        
        descripitonTextField.inputAccessoryView = toolBar
        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        timePicker.addTarget(self, action: #selector(timePickerAction(_:)), for: .valueChanged)
        self.fromDateTextField.inputView = timePicker
        self.fromDateTextField.delegate = self
        self.fromDateTextField.inputAccessoryView = toolBar
        self.toDateTextField.inputView = timePicker
        self.toDateTextField.delegate = self
        self.toDateTextField.inputAccessoryView = toolBar
        self.descripitonTextField.delegate = self
    }
    
    private func setAttendanceApprover(_ data : [AttendanceUser]){
        
        let arrString = data.map{$0.name}
        
        approvedByTextField.delegate = self
        approvedByTextField.optionArray = arrString
        approvedByTextField.selectedIndex = 0
        approvedByTextField.text = arrString[0]
        approvedByTextField.selectedRowColor = .lightGray
    }
    
    private func setLeaveType(_ data : [AttendanceRemainPermission]){
        var arrString = [String]()
        data.forEach { (d) in
            arrString.append(d.nameEn)
        }
        self.leaveTypeTextField.delegate = self
        self.leaveTypeTextField.optionArray = arrString
        self.leaveTypeTextField.selectedIndex = 0
        self.leaveTypeTextField.text = arrString[0]
        self.leaveTypeTextField.selectedRowColor = .lightGray
    }
    
    @objc func timePickerAction(_ sender : UIDatePicker){
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd" + (absentTypeTextField.selectedIndex == 3 ? "" : " hh:mm:ss")
        let strDate = dateFormatter.string(from: sender.date)
        switch activeTextField {
            case fromDateTextField :
                fromDateTextField.text = strDate
            case toDateTextField :
                toDateTextField.text = strDate
            default :
                print("DEF")
        }
    }
    
    @objc func donePicker(_ sender : UIBarButtonItem){
        activeTextField.resignFirstResponder()
    }
    
    private func setData(_ attendnace : Attendance){
        self.editUsernameLabel.text = "\("edit on".localized) \(attendnace.name)"
    }
    
    @IBAction func buttonPressed(_ sender : UIButton){
        switch sender {
            case cancelButton:
                self.dismiss(animated: true) {
                }
            case confirmButton :
                DispatchQueue.main.async {
                    guard let user = AppDelegate.user else { return }
                        switch self.approvedView.isHidden {
                            case true :
                                let mission = Mission(
                                    type: self.typeList[self.absentTypeTextField.selectedIndex ?? 0],
                                    reason: self.descripitonTextField.text ?? "",
                                    shift: (self.selectionShiftTextField.isHidden) ? self.shift : self.shiftList[self.selectionShiftTextField.selectedIndex ?? 2],
                                    staffIdNumber: "\(self.attendanceAbsent.id)",
                                    userId: user.id,
                                    fromDate: self.fromDateTextField.text ?? "\(Date())",
                                    toDate: self.toDateTextField.text ?? "\(Date())"
                                )
                                self.attendanceViewModel.postMission(mission: mission) { (status) in
                                    switch status {
                                        case true :
                                            self.dismiss(animated: true) {
                                                if let onDone = self.onReloadBack {
                                                    onDone(true)
                                                }
                                            }
                                        case false :
                                            print("FALSE")
                                    }
                                }
                            
                            case false :
                                
                                var dateFrom = Date().toString(toFormat: .yyyymdd)
                                var dateTo = Date().toString(toFormat: .yyyymdd)
                                
                                switch self.selectionShiftTextField.selectedIndex {
                                    case 0 :
                                        dateFrom = dateFrom + " 08:00:00"
                                        dateTo = dateTo + " 12:00:00"
                                    case 1 :
                                        dateFrom = dateFrom + " 13:30:00"
                                        dateTo = dateTo + " 17:30:00"
                                    default:
                                        dateFrom = dateFrom + " 08:00:00"
                                        dateTo = dateTo + " 17:30:00"
                                }
                                
                                let permission = Permission(
                                    userId: "\(self.attendanceAbsent.id)",
                                    editorId: user.id,
                                    approvedBy: self.attendanceApproverList[self.approvedByTextField.selectedIndex ?? 0].id,
                                    reason: self.descripitonTextField.text ?? "",
                                    dateFrom: dateFrom,
                                    dateTo: dateTo,
                                    leaveType: self.remainPermission[self.leaveTypeTextField.selectedIndex ?? 0].id
                                )
                                
                                self.attendanceViewModel.postPermission(permission: permission) { (status) in
                                    switch status {
                                        case true :
                                            self.dismiss(animated: true) {
                                                if let onDone = self.onReloadBack {
                                                    onDone(true)
                                                }
                                            }
                                        case false :
                                            print("FALSE")
                                    }
                                }
                    }
                }
            default:
                print("DEF")
        }
    }
}

extension EditAbsentAlertViewController : UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case absentTypeTextField, approvedByTextField, self.selectionShiftTextField, self.leaveTypeTextField:
            return false
        default:
            return true
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.typeList.count
    }
    
    
}
