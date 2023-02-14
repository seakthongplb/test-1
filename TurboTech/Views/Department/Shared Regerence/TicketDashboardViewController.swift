//
//  TicketDashboardViewController.swift
//  TurboTech
//
//  Created by sq on 7/14/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Charts

class TicketDashboardViewController: UIViewController {

    @IBOutlet weak var picChartLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var selectedDateTextField : UITextField!
    
    var month : Int = 0
    var year : Int = 0
    lazy var picker = UIPickerView()
    lazy var datePicker = MonthYearPickerView()
    let MONTHS = ["month".localized, "january".localized, "february".localized, "march".localized, "april".localized, "may".localized, "june".localized, "july".localized, "august".localized, "september".localized, "october".localized, "november".localized, "december".localized]
    
    var ticketDepartmentReportList = [TicketReport]()
    var ticketStatusReportList = [TicketReport]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        localized()
        fetchData()
        setUpChart()
        customizePieChart(data: ticketDepartmentReportList)
        customizeBarChart(data: ticketStatusReportList)
    }
    
    private func setup(){
        
        selectedDateTextField.delegate = self
        selectedDateTextField.inputView = self.datePicker
        self.datePicker.setYear(fromYear: 2019, toYear: Calendar.current.component(.year, from: Date()))
        self.datePicker.onDateSelected = {(month, year) in
            self.selectedDateTextField.text = "\(self.MONTHS[month]) \(year)"
            self.fetchDataByMonthYear(month: month, year: year)
        }
        let date = Date()
        let calendar = Calendar.current
        let m = calendar.component(.month, from: date)
        let y = calendar.component(.year, from: date)
        self.selectedDateTextField.text = "\(self.MONTHS[m]) \(y)"
        
        self.addDoneButtonOnKeyboard()
    }
    
    private func localized(){
        self.navigationItem.title = "ticket dashboard".localized
        self.picChartLabel.text = "ticket by department".localized
        self.barChartLabel.text = "ticket by status".localized
    }
    
    private func fetchData(){
            let date = Date()
            let calendar = Calendar.current
            let m = calendar.component(.month, from: date)
            let y = calendar.component(.year, from: date)
            self.fetchDataByMonthYear(month: m, year: y)
    }
    
    private func fetchDataByMonthYear(month m: Int, year y: Int){
        self.month = m
        self.year = y
        let statuses = [TicketStatusEnum.open, TicketStatusEnum.progress, TicketStatusEnum.closed, TicketStatusEnum.waiting]
        let ticketViewModel = TicketViewModel()
        DispatchQueue.main.async {
            ticketViewModel.getAdminChartTicket(month: "\(m)", year: "\(y)") { (chartData) in
                
                self.ticketStatusReportList = []
                self.ticketStatusReportList.append(TicketReport(name: statuses[0].rawValue.localized, value: chartData.open))
                self.ticketStatusReportList.append(TicketReport(name: statuses[1].rawValue.localized, value: chartData.inProgress))
                self.ticketStatusReportList.append(TicketReport(name: statuses[2].rawValue.localized, value: chartData.closed))
                self.ticketStatusReportList.append(TicketReport(name: statuses[3].rawValue.localized, value: chartData.waitForResponse))
                
                self.ticketDepartmentReportList = []
                if chartData.departmentFND != 0 {
                    self.ticketDepartmentReportList.append(TicketReport(name: "FND", value: chartData.departmentFND))
                }
                
                if chartData.departmentBSD != 0 {
                    self.ticketDepartmentReportList.append(TicketReport(name: "BSD", value: chartData.departmentBSD))
                }
                
                if chartData.departmentITD != 0 {
                    self.ticketDepartmentReportList.append(TicketReport(name: "ITD", value: chartData.departmentITD))
                }
                
                if chartData.departmentOPD != 0 {
                    self.ticketDepartmentReportList.append(TicketReport(name: "OPD", value: chartData.departmentOPD))
                }
                
                if chartData.departmentTOP != 0 {
                    self.ticketDepartmentReportList.append(TicketReport(name: "TOP", value: chartData.departmentTOP))
                }
                                
                self.customizeBarChart(data: self.ticketStatusReportList)
                self.customizePieChart(data: self.ticketDepartmentReportList)
            }
            
        }
    }
    
    func setUpChart(){
        barChartView.delegate = self
        pieChartView.delegate = self
        barChartView.noDataText = "no ticket status".localized
        pieChartView.noDataText = "no ticket in department".localized
    }
    
}


//MARK: - Customize Chart
extension TicketDashboardViewController {
    func customizePieChart(data : [TicketReport]) {
    
//        1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<data.count {
        let dataEntry = PieChartDataEntry(value: data[i].value, label: data[i].name, data: data[i].name as AnyObject)
        dataEntries.append(dataEntry)
        }
        
//        2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.sliceSpace = 4.0
        pieChartDataSet.selectionShift = 0.0
        let allColors = [UIColor.systemPink, UIColor.systemBlue, UIColor.systemOrange, UIColor.systemRed, UIColor.systemTeal,UIColor.systemBlue, UIColor.systemPink, UIColor.systemOrange, UIColor.systemRed, UIColor.systemTeal]
        pieChartDataSet.colors = allColors
        pieChartDataSet.drawValuesEnabled = true
        pieChartDataSet.valueFont = UIFont.systemFont(ofSize: 12.0)
        

//        3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
//        4. Assign it to the chart’s data
        pieChartView.legend.enabled = false
        pieChartView.drawHoleEnabled = false
        pieChartView.drawEntryLabelsEnabled = true
        pieChartView.drawSlicesUnderHoleEnabled = false
        pieChartView.data = pieChartData
        pieChartView.animate(yAxisDuration: 1.5)
    }
    
    func customizeBarChart(data : [TicketReport]) {
        
        var dataEntries: [ChartDataEntry] = []
        var dataPoints = [String]()
        let formatter = BarChartFormatter()
        
        for i in 0..<data.count {
            dataPoints.append(data[i].name)
            let dataEntry = BarChartDataEntry(x: Double(i), y: data[i].value, data: data[i].name as AnyObject)
          dataEntries.append(dataEntry)
        }
        
        formatter.setValues(values: dataPoints)
        let xaxis:XAxis = XAxis()
        
        barChartView.noDataFont = UIFont(name: "Quicksand-bold", size: 26)!
        barChartView.noDataTextAlignment = .center
        if DeviceTraitStatus.current == .wRhR {
            barChartView.noDataFont = UIFont(name: "Quicksand-bold", size: 26)!
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "@REPORT")
        chartDataSet.colors = [COLOR.BLUE]
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = dataEntries.isEmpty ? .none : chartData
        
        xaxis.valueFormatter = formatter
        barChartView.xAxis.axisLineColor = COLOR.BLUE
        barChartView.xAxis.axisLineWidth = 2.0
        barChartView.leftAxis.axisLineWidth = 2.0
        barChartView.leftAxis.axisLineColor = COLOR.BLUE
        barChartView.xAxis.gridLineWidth = 2.0
        barChartView.legend.enabled = false // Turn off legend '@REPORT'
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = true
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        barChartView.chartDescription?.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.decimals = 0
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.6, easingOption: .easeInBounce)
        barChartView.leftAxis.axisMinimum = 0.0
//        barChartView.leftAxis.axisMaximum = 100.0
        barChartView.setScaleEnabled(false)
    }
}

//MARK: - Chart Action
extension TicketDashboardViewController : ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if chartView == pieChartView {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TicketTableViewControllerID") as! TicketTableViewController
            print("DEPARTMENT : ", self.ticketDepartmentReportList[Int(highlight.x)].name)
            vc.dept = self.ticketDepartmentReportList[Int(highlight.x)].name
            vc.month = self.month
            vc.year = self.year
            self.navigationController?.pushViewController(vc, animated: true)
        } else if chartView == barChartView {
        }
    }
    
}

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter
{
    var names = [String]()

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if names.count == 0 {
            return ""
        } else {
            return names[Int(value)]
        }
    }

    public func setValues(values: [String]) {
        self.names = values
    }
}

//  MARK: - PickerDS, Delegate
extension TicketDashboardViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.picker.reloadAllComponents()
//        self.picker.selectRow(selectedIndex, inComponent: 0, animated: true)
//        self.pickerView(self.picker, didSelectRow: selectedIndex, inComponent: 0)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case selectedDateTextField :
            return false
        default:
            return true
        }
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
        
        selectedDateTextField.inputAccessoryView = toolBar
        selectedDateTextField.autocorrectionType = .no

    }
    
    @objc func donePicker(_ sender : UIBarButtonItem){
        selectedDateTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
}
