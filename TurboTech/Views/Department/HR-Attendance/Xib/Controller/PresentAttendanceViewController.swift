//
//  PresentAttendanceViewController.swift
//  TurboTech
//
//  Created by Sov Sothea on 6/10/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PresentAttendanceViewController: UIViewController {

    // IBOutlet of PresentAttendanceViewController
    @IBOutlet weak var lbHeaderPresentAttendanceOutlet: UILabel!
    @IBOutlet weak var btnBackPresentAttendanceOutlet: UIButton!
    @IBOutlet weak var presentAttendanceSegmentedOutlet: UISegmentedControl!
    @IBOutlet weak var presentAttendanceTableViewOutlet: UITableView!
    @IBOutlet weak var attendanceOverallView : AttendanceOverallView!
    
    // Declare Variable
    var attendnaceType : String!
    var attendnacePresentationList = [String : [AttendancePresent]]()
    var attendnaceAbsentList = [String : [AttendanceAbsence]]()
    var attendanceReportList = [String : Int]()
    
    var selectedDate : Date = Date()
    let attandanceViewModel = AttandanceViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Call Function
        registerTableViewCell()
        customPresentAttendanceViewController()
        presentAttendanceSegmented(presentAttendanceSegmentedOutlet)
        addGestureSwapeToSegment()
        localized()
        setData()
        self.attendanceOverallView.target = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    func localized(){
        self.lbHeaderPresentAttendanceOutlet.text = "present".localized
        self.presentAttendanceSegmentedOutlet.setTitle("today".localized, forSegmentAt: 0)
        self.presentAttendanceSegmentedOutlet.setTitle("overall".localized, forSegmentAt: 1)
    }
    
    func setData(){
        self.attendanceOverallView.attendanceReportList = self.attendanceReportList
        
        self.attendanceOverallView.setData(
            date: selectedDate.toString(toFormat: .yyyymdd),
            mPresent : attendanceReportList["present morning"],
            mLate : attendanceReportList["late morning"],
            mAbsent : attendanceReportList["absent morning"],
            mPermission : attendanceReportList["permission morning"],
            aPresent : attendanceReportList["present afternoon"],
            aLate : attendanceReportList["late afternoon"],
            aAbsent : attendanceReportList["absent afternoon"],
            aPermission : attendanceReportList["permission afternoon"]
        )
        self.attendanceOverallView.onReponseDateStatus = {(value) in
            print("VALUE : ", value)
            switch value {
                case -1 :
                    self.decreaseData()
                case 0 :
                    self.popUpDateTime()
                case 1 :
                    self.increaseDate()
                default:
                    print("Def")
            }
        }
    }

    func registerTableViewCell() {
        presentAttendanceTableViewOutlet.tableFooterView = UIView()
        presentAttendanceTableViewOutlet.register(UINib(nibName: "PresentAttendanceTableViewCell", bundle: nil), forCellReuseIdentifier: "presentAttendanceCellItem")
        presentAttendanceTableViewOutlet.register(UINib(nibName: "TodayTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "todayHeader")

        presentAttendanceTableViewOutlet.delegate = self
        presentAttendanceTableViewOutlet.dataSource = self
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
            if presentAttendanceSegmentedOutlet.selectedSegmentIndex == 0 {
                presentAttendanceSegmentedOutlet.selectedSegmentIndex = 0
            }
            else{
                presentAttendanceSegmentedOutlet.selectedSegmentIndex -= 1
            }
        }
        else{
            if presentAttendanceSegmentedOutlet.selectedSegmentIndex == 1 {
                presentAttendanceSegmentedOutlet.selectedSegmentIndex = 1
            }
            else{
                presentAttendanceSegmentedOutlet.selectedSegmentIndex += 1
            }
        }
        presentAttendanceSegmented(presentAttendanceSegmentedOutlet)
    }

    func customPresentAttendanceViewController() {
        lbHeaderPresentAttendanceOutlet.textColor = COLOR.COLOR_PRESENT
    }

    // Action Button
    @IBAction func btnBackPresentAttendance(_ sender: UIButton) {
        sender.pulsate()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func presentAttendanceSegmented(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.presentAttendanceTableViewOutlet.isHidden = false
            self.attendanceOverallView.isHidden = true
            view.backgroundColor = COLOR.WHITE
            break
        default:
            self.presentAttendanceTableViewOutlet.isHidden = true
            self.attendanceOverallView.isHidden = false
            view.backgroundColor = COLOR.WHITE
        }
    }
}

extension PresentAttendanceViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        attendanceReportList[attendnaceType + " \(section == 0 ? "morning" : "afternoon")"] ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        self.attandanceViewModel.getTimeValue() == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "todayHeader") as! TodayTableViewHeader
        print("TABLE VIEW : ", attendanceReportList[attendnaceType + " \(section == 0 ? "morning" : "afternoon")"] ?? 0)
        header.setData(
            date: section == 0 ? "morning".localized : "afternoon".localized,
            statusNumber: "\(attendnaceType == "present" ? "present".localized : "late".localized)" + ": \(attendanceReportList[attendnaceType + " \(section == 0 ? "morning" : "afternoon")"] ?? 0)")
        return header
    }

    func popUpDateTime(){
        let st = UIStoryboard(name: "SharedStoryboard", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "PopUpDateTimeViewControllerID") as! PopUpDateTimeViewController
        vc.delegate = self
        vc.currentDate = selectedDate
        self.present(vc, animated: true, completion: nil)
    }

    func increaseDate(){
        if Date().toString(toFormat: .mmmddyyy) == selectedDate.toString(toFormat: .mmmddyyy) {
            return
        }
        fetchData(Date(timeInterval: 24*60*60, since: selectedDate))
    }

    func decreaseData(){
        fetchData(Date(timeInterval: -24*60*60, since: selectedDate))
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        68
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == presentAttendanceTableViewOutlet,
            let cell = tableView.dequeueReusableCell(withIdentifier: "presentAttendanceCellItem") as? PresentAttendanceTableViewCell {
            cell.selectionStyle = .none
            cell.setData(attendnacePresentationList[ self.attendnaceType + " " + "\(indexPath.section == 0 ? "morning" : "afternoon")"]![indexPath.row], isPresent: self.attendnaceType == "present" ? true : false)
            if !(self.attendnaceType == "present") {
                cell.onButtonPressed = {
                    let editData = self.attendnacePresentationList[ self.attendnaceType + " " + "\(indexPath.section == 0 ? "morning" : "afternoon")"]![indexPath.row]
                    let vc = LateExceptionViewController(nibName: "LateExceptionViewController", bundle: nil)
                    vc.editData = editData
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.onReloadBack = { status in
                        self.fetchData(Date())
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
//                MARK: - Edit Present List
                cell.onButtonPressed = {
                    let editData = self.attendnacePresentationList[ self.attendnaceType + " " + "\(indexPath.section == 0 ? "morning" : "afternoon")"]![indexPath.row]
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
            }
            return cell
        }
        return UITableViewCell()
    }

    func fetchData(_ date : Date){
        self.selectedDate = date
        DispatchQueue.main.async {
            self.attandanceViewModel.fetchAttendance(today: date.toString(toFormat: .yyyymdd)) { (presentList, absentList, reportList) in
                self.attendnacePresentationList = presentList
                self.attendnaceAbsentList = absentList
                self.attendanceReportList = reportList
                self.presentAttendanceTableViewOutlet.reloadData()
                self.setData()
            }
        }
    }
}

extension PresentAttendanceViewController : DateTimePopUpDelegate {
    func responsePickDate(_ date: Date) {
        print("Delegate date : ", date)
        self.fetchData(date)
    }
}
