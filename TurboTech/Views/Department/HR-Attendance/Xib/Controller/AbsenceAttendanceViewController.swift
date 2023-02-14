//
//  AbsenceAttendanceViewController.swift
//  TurboTech
//
//  Created by Sov Sothea on 6/10/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class AbsenceAttendanceViewController: UIViewController {
    private let type = ["absent morning","absent afternoon","permission morning","permission afternoon"]
    let am = ["present morning","early morning","late morning","present afternoon","early afternoon","late afternoon"]
    // IBOutlet of AbsenceAttendanceViewController
    @IBOutlet weak var lbHeaderAbsenceAttendanceOutlet: UILabel!
    @IBOutlet weak var btnBackAbsenceAttendanceOutlet: UIButton!
    @IBOutlet weak var absenceAttendanceSegmentedOutlet: UISegmentedControl!
    @IBOutlet weak var absenceAttendanceTableViewOutlet: UITableView!

    // Declare Variable
    var selectedDate : Date = Date()
    let attandanceViewModel = AttandanceViewModel()
    var attendnaceAbsentList = [String : [AttendanceAbsence]]()
    var attendanceReportList = [String : Int]()
    var tableTitle : String = "absent"
    
    var activeTextField = UITextField()
    
    var option = ["missed scan".localized, "others".localized]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Call Function
        registerTableViewCell()
        customAbsenceAttendanceViewController()
        absenceAttendanceSegmented(absenceAttendanceSegmentedOutlet)
        addGestureSwapeToSegment()
        localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    func localized(){
        self.lbHeaderAbsenceAttendanceOutlet.text = "absence".localized
        self.absenceAttendanceSegmentedOutlet.setTitle("absent".localized, forSegmentAt: 0)
        self.absenceAttendanceSegmentedOutlet.setTitle("permission".localized, forSegmentAt: 1)
    }
    
    func fetchData(_ date : Date){
        self.selectedDate = date
        DispatchQueue.main.async {
            self.attandanceViewModel.fetchAttendance(today: date.toString(toFormat: .yyyymdd)) { (presentList, absentList, reportList) in
                self.attendnaceAbsentList = absentList
                self.attendanceReportList = reportList
                self.absenceAttendanceTableViewOutlet.reloadData()
            }
        }
    }

    func registerTableViewCell() {
        absenceAttendanceTableViewOutlet.tableFooterView = UIView()
        absenceAttendanceTableViewOutlet.register(UINib(nibName: "AbsenceAttendanceTableViewCell", bundle: nil), forCellReuseIdentifier: "absenceAttendanceCellItem")
        absenceAttendanceTableViewOutlet.register(UINib(nibName: "PermissionAttendanceTableViewCell", bundle: nil), forCellReuseIdentifier: "permissionAttendanceTableViewCell")
        absenceAttendanceTableViewOutlet.register(UINib(nibName: "TodayTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "todayHeader")
        absenceAttendanceTableViewOutlet.delegate = self
        absenceAttendanceTableViewOutlet.dataSource = self
    }

    func addGestureSwapeToSegment() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwiped(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }

    @objc func handleSwiped(_ sender : UISwipeGestureRecognizer){
        if sender.direction == .right {
            if absenceAttendanceSegmentedOutlet.selectedSegmentIndex == 0 {
                absenceAttendanceSegmentedOutlet.selectedSegmentIndex = 0
            }
            else{
                absenceAttendanceSegmentedOutlet.selectedSegmentIndex -= 1
            }
        }
        else{
            if absenceAttendanceSegmentedOutlet.selectedSegmentIndex == 1 {
                absenceAttendanceSegmentedOutlet.selectedSegmentIndex = 1
            }
            else{
                absenceAttendanceSegmentedOutlet.selectedSegmentIndex += 1
            }
        }
        absenceAttendanceSegmented(absenceAttendanceSegmentedOutlet)
    }

    func customAbsenceAttendanceViewController() {
        lbHeaderAbsenceAttendanceOutlet.textColor = COLOR.COLOR_ABSENCE
    }
    
    @IBAction func btnBackAbsenceAttendance(_ sender: UIButton) {
        sender.pulsate()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func absenceAttendanceSegmented(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            case 0:
                self.tableTitle = "absent"
            case 1 :
                self.tableTitle = "permission"
            default:
                print("Def")
        }
        self.absenceAttendanceTableViewOutlet.reloadData()
    }
}

extension AbsenceAttendanceViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if attendnaceAbsentList["\(self.tableTitle == "absent" ? "absent" : "permission")" + " morning"]?.count ?? 0 == 0 && attendnaceAbsentList["\(self.tableTitle == "absent" ? "absent" : "permission")" + " afternoon"]?.count ?? 0 == 0 {
            tableView.setEmptyTableView(UIImage(named: "no_task"), "no \(tableTitle)")
        } else {
            tableView.restore()
        }
        
        return attendnaceAbsentList["\(self.tableTitle == "absent" ? "absent" : "permission")" + " \(section == 0 ? "morning" : "afternoon")"]?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        self.attandanceViewModel.getTimeValue() == 0 ? 1 : 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if attandanceViewModel.getTimeValue() == 0 && section == 1 {
            return UIView()
        }
        if attendnaceAbsentList["\(self.tableTitle == "absent" ? "absent" : "permission")" + " morning"]?.count ?? 0 == 0 && attendnaceAbsentList["\(self.tableTitle == "absent" ? "absent" : "permission")" + " afternoon"]?.count ?? 0 == 0 {
            return UIView()
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "todayHeader") as! TodayTableViewHeader
        let str = section == 0 ? "morning" : "afternoon"
        let value = tableTitle == "absent" ? attendanceReportList["absent \(str)"] : attendanceReportList["permission \(str)"]
        header.setData(date: section == 0 ? "morning".localized : "afternoon".localized, statusNumber: "\(tableTitle)".localized + ": \(value ?? 0)")
         return header
     }

     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 68
     }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.tableTitle == "absent" {
            case true:
                let cell = tableView.dequeueReusableCell(withIdentifier: "absenceAttendanceCellItem") as! AbsenceAttendanceTableViewCell
                cell.selectionStyle = .none
                cell.setData(attendnaceAbsentList["\(self.tableTitle == "absent" ? "absent" : "permission")" + " \(indexPath.section == 0 ? "morning" : "afternoon")"]?[indexPath.row])
                if absenceAttendanceSegmentedOutlet.selectedSegmentIndex == 1 {
                    cell.isEditToFalse()
                }
                cell.onButtonPressed = {
                    print(indexPath)
                    guard let editData = self.attendnaceAbsentList["absent" + " \(indexPath.section == 0 ? "morning" : "afternoon")"]?[indexPath.row] else { return }
//                    MARK: - Edit Absent Alert View Controller
                    let vc = EditAbsentAlertViewController(nibName: "EditAbsentAlertViewController", bundle: nil)
                    vc.attendanceAbsent = editData
                    vc.shift = indexPath.section == 0 ? "am" : "pm"
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.onReloadBack = { status in
                        self.fetchData(Date())
                    }
                    self.present(vc, animated: true){
                        self.fetchData(Date())
                    }
                }
                return cell
            case false:
                let cell = tableView.dequeueReusableCell(withIdentifier: "permissionAttendanceTableViewCell") as! PermissionAttendanceTableViewCell
                cell.selectionStyle = .none
                cell.setData(permission: attendnaceAbsentList["permission" + " \(indexPath.section == 0 ? "morning" : "afternoon")"]?[indexPath.row])
                return cell
            
        }
       
    }
    
}

extension AbsenceAttendanceViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.option.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.option[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activeTextField.text = self.option[row]
    }
}

extension AbsenceAttendanceViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.tag == 9999 ? true : false
    }
    
    @objc func donePicker(_ sender : UIBarButtonItem){
        activeTextField.resignFirstResponder()
    }
    
}
