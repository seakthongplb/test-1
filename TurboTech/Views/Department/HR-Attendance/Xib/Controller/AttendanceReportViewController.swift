//
//  AttendanceReportViewController.swift
//  TurboTech
//
//  Created by wo on 9/12/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Charts
import LGButton

class AttendanceReportViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var moreButton : UIButton!
    
    @IBOutlet weak var dailyContainerView : UIView!
    @IBOutlet weak var dailyLabel : UILabel!
    @IBOutlet weak var dailyTimeTextField : UITextField!
    
    @IBOutlet weak var monthlyContainerView : UIView!
    @IBOutlet weak var monthlySegment : UISegmentedControl!
    @IBOutlet weak var chooseMonthYearTextField : UITextField!
    
    @IBOutlet weak var chartView : PieChartView!
    @IBOutlet weak var chartTitleLabel : UILabel!
    @IBOutlet weak var earlyLGButton : LGButton!
    @IBOutlet weak var lateLGButton : LGButton!
    
    var picker = UIPickerView()
    var monthYearPicker = MonthYearPickerView()
    var activeTextField = UITextField()
    
    var isDaily = true
    var attandanceViewModel = AttandanceViewModel()
    var attendancePresentationList = [String : [AttendancePresent]]()
    var attendnaceAbsentList = [String : [AttendanceAbsence]]()
    var attendanceReportList = [String : Int]()
    var monthlyReport = [Double]()
    var monthlyEarlyList = [AttendanceReportDetail]()
    var monthlyLateList = [AttendanceReportDetail]()
    
    var dailyOption = ["am", "pm", "today"]
    let MONTHS = ["month".localized, "january".localized, "february".localized, "march".localized, "april".localized, "may".localized, "june".localized, "july".localized, "august".localized, "september".localized, "october".localized, "november".localized, "december".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setup(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        setDailyData(shift: self.attandanceViewModel.getTimeValue())
        
        let date = Date()
        let calendar = Calendar.current
        let m = calendar.component(.month, from: date)
        let y = calendar.component(.year, from: date)
        self.fetchMonthlyReport(month: m, year: y)
        
        self.chooseMonthYearTextField.text = "\(self.MONTHS[m]) \(y)"
        self.chooseMonthYearTextField.delegate = self
        self.chooseMonthYearTextField.inputView = monthYearPicker
        monthYearPicker.setYear(fromYear: 2017, toYear: 2027)
        monthYearPicker.onDateSelected = {(month, year) in
            if year > y { return } else if year == y && month > m { return }
            self.chooseMonthYearTextField.text = "\(self.MONTHS[month]) \(year)"
            self.fetchMonthlyReport(month: month, year: year)
            self.setMonthlyReport()
        }
        
        self.picker.delegate = self
        self.picker.dataSource = self
        self.dailyTimeTextField.delegate = self
        self.dailyTimeTextField.inputView = picker
        
        self.monthlySegment.addTarget(self, action: #selector(segmentChangeValue(_:)), for: .valueChanged)
        self.monthlySegment.selectedSegmentIndex = 0
    }
    
    func setDailyData(shift : Int){
        self.dailyContainerView.isHidden = !isDaily
        self.monthlyContainerView.isHidden = isDaily
        var str = ""
        var early = 0.0
        var late = 0.0
        var absent = 0.0
        var total = 0.0
        switch  shift {
        case 0:
            str = "morning"
            self.dailyTimeTextField.text = "am".localized
        case 1 :
            str = "afternoon"
            self.dailyTimeTextField.text = "pm".localized
        case 2 :
            str = "full"
            self.dailyTimeTextField.text = "today".localized
        default:
            print("DEF")
        }
        
        if str != "full"{
            early = (Double(self.attendanceReportList["present \(str)"] ?? 0))
            late = (Double(self.attendanceReportList["late \(str)"] ?? 0))
            absent = (Double(self.attendanceReportList["absent \(str)"] ?? 0))
            total = early + late + absent
        } else {
            early = (Double(self.attendanceReportList["present morning"] ?? 0)) + (Double(self.attendanceReportList["present afternoon"] ?? 0))
            late = (Double(self.attendanceReportList["late morning"] ?? 0)) + (Double(self.attendanceReportList["late afternoon"] ?? 0))
            absent = (Double(self.attendanceReportList["absent morning"] ?? 0)) + (Double(self.attendanceReportList["absent afternoon"] ?? 0))
            total = early + late + absent
        }
        
        var dataPoints = [String]()
        var values = [Double]()
        
        dataPoints.append("early")
        dataPoints.append("late")
        dataPoints.append("absent")
        values.append(early / total)
        values.append(late / total)
        values.append(absent / total)
        self.setChart(dataPoints: dataPoints, values: values, label: "daily report")
    }
    
    func setMonthlyReport(){
        self.dailyContainerView.isHidden = !isDaily
        self.monthlyContainerView.isHidden = isDaily
        print(self.dailyContainerView.isHidden, self.monthlyContainerView.isHidden)
        if monthlyReport.isEmpty {
            print("THIS IS WORD")
            self.setChart(dataPoints: ["early", "late", "absent"], values: [0.0,0.0,0.0], label: "monthly report")
            return
        }
        self.setChart(dataPoints: ["early", "late", "absent"], values: [monthlyReport[0]/100,monthlyReport[1]/100,monthlyReport[2]/100], label: "monthly report")
    }
    
    func fetchMonthlyReport(month : Int, year : Int){
        DispatchQueue.main.async {
            self.attandanceViewModel.fetchAttendanceMonthReport(month: month, year: year) { (early, late, absent) in
                self.monthlyReport = [early, late, absent]
            }
            
            self.attandanceViewModel.fetchAttendanceMonthlyEarlyReportDetail(month: month, year: year) { (data) in
                self.monthlyEarlyList = data
            }
            
            self.attandanceViewModel.fetchAttendanceMonthlyLateReportDetail(month: month, year: year) { (data) in
                self.monthlyLateList = data
            }
        }
    }
    
    func setChart(dataPoints : [String], values : [Double], label : String){
        if values.count <= 0 {
            return
        }
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as AnyObject)
            dataEntry.accessibilityLabel = dataPoints[i]
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries)
        pieChartDataSet.selectionShift = 0.0
        pieChartDataSet.colors = [COLOR.COLOR_PRESENT, COLOR.COLOR_LATE, COLOR.COLOR_ABSENCE]
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .percent
        format.generatesDecimalNumbers = true
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        self.chartView.data = pieChartData
        self.chartView.animate(yAxisDuration: 1.5)
        let legend = self.chartView.legend
        var legendEntries = [LegendEntry]()
        for index in 0...values.count - 1 {
            let fromSize = CGFloat.nan
            let legendEntry = LegendEntry(label: dataPoints[index], form: .default, formSize: fromSize, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: pieChartDataSet.colors[index])
            legendEntries.append(legendEntry)
        }
        legend.horizontalAlignment = .center
        legend.setCustom(entries: legendEntries)
        legend.orientation = .horizontal
        legend.textColor = UIColor.black
        legend.xEntrySpace = 60
        legend.font.withSize(20)
        self.chartView.drawCenterTextEnabled = false
        chartTitleLabel.text = label
    }
    
    @IBAction func moreButtonPressed(_ sender : Any){
        let alert = UIAlertController(title: "report", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dialy report".localized, style: .default, handler: { (action) in
            self.isDaily = true
            self.setDailyData(shift: self.attandanceViewModel.getTimeValue())
        }))
        alert.addAction(UIAlertAction(title: "monthly report".localized, style: .default, handler: { (action) in
            self.isDaily = false
            self.setMonthlyReport()
        }))
        
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buttonPressed(_ sender : LGButton){
        switch self.isDaily {
        case true :
            print("Daily")
            var str = ""
            switch sender {
                case earlyLGButton:
                    str = "present"
                case lateLGButton :
                    str = "late"
                default:
                    print("DEF")
            }
            
            let storyboard = UIStoryboard(name: BOARD.ABOUTUS, bundle: nil)
            let presentAttendanceVC = storyboard.instantiateViewController(withIdentifier: "PresentAttendanceViewControllerID") as! PresentAttendanceViewController
            presentAttendanceVC.modalPresentationStyle = .fullScreen
            presentAttendanceVC.attendanceReportList = self.attendanceReportList
            presentAttendanceVC.attendnacePresentationList = self.attendancePresentationList
            presentAttendanceVC.attendnaceAbsentList = self.attendnaceAbsentList
            presentAttendanceVC.attendanceReportList = self.attendanceReportList
            presentAttendanceVC.attendnaceType = str
            self.navigationController?.pushViewController(presentAttendanceVC, animated: true)
        case false :
            var isEarly = true
            switch sender {
                case earlyLGButton:
                    isEarly = true
                case lateLGButton :
                    isEarly = false
                default:
                    print("DEF")
            }
            
            let vc = AttendanceReportDetailTableViewController(nibName: "AttendanceReportDetailTableViewController", bundle: nil)
            vc.data = isEarly ? self.monthlyEarlyList : self.monthlyLateList
            vc.isEarly = isEarly
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func segmentChangeValue(_ sender : UISegmentedControl){
        switch sender.selectedSegmentIndex {
            case 0 :
                print("0")
            case 1 :
                print("1")
                self.chooseMonthYearTextField.text = "New Custom Month"
                self.presentChooseDate()
            
            default :
                print("STH")
        }
    }
    
    func presentChooseDate(){
        let vc =  SelectBetweenDateViewController(nibName: "SelectBetweenDateViewController", bundle: nil)
        vc.onDoneBlock = ({ start, to in
            print(start, to)
        })
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.onDoneBlock = { (startDate, toDate) in
            DispatchQueue.main.async {
                self.attandanceViewModel.fetchAttendanceMonthly(startDate: startDate, endDate: toDate) { (early, late, absent) in
                    var dataPoints = [String]()
                    var values = [Double]()
                    
                    dataPoints.append("early")
                    dataPoints.append("late")
                    dataPoints.append("absent")
                    
                    let total = early + late + absent
                    values.append(early / total)
                    values.append(late / total)
                    values.append(absent / total)
                    self.setChart(dataPoints: dataPoints, values: values, label: "custom date")
                    self.chooseMonthYearTextField.text = "\(startDate) : \(toDate)"
                }
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
}

extension AttendanceReportViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        if self.monthlySegment.selectedSegmentIndex == 1 && textField == self.chooseMonthYearTextField {
            self.presentChooseDate()
            textField.resignFirstResponder()
        }
        addDoneButtonOnKeyboard()
    }
    
    
    @objc func donePicker(_ sender : UIBarButtonItem){
        self.activeTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
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
        self.activeTextField.inputAccessoryView = toolBar
    }
}

extension AttendanceReportViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.dailyOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activeTextField.text = self.dailyOption[row]
        self.setDailyData(shift: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.dailyOption[row]
    }
}
