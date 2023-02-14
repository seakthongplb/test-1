//
//  CRMDashboardTableViewController.swift
//  TurboTech
//
//  Created by sq on 6/29/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import FittedSheets

class CRMDashboardTableViewController: UITableViewController {
    
//    MARK: - @IBOutlet
    @IBOutlet weak var leadTableHeaderView: UIView!
    @IBOutlet weak var circleProgressBarView: MBCircularProgressBarView!
    @IBOutlet weak var totalLeadLabel: UILabel!
    @IBOutlet weak var titleLeadLabel: UILabel!
    @IBOutlet weak var convertedLeadImageView: UIImageView!
    @IBOutlet weak var unConvertLeadImageView: UIImageView!
    @IBOutlet weak var covertedLeadLabel: UILabel!
    @IBOutlet weak var unConvertedLeadLabel: UILabel!
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var datePickerTextField : UITextField!
    var sheetController : SheetViewController!
    // MARK: - Data
    lazy var picker = UIPickerView()
    lazy var datePicker = MonthYearPickerView()
    let MONTHS = ["month".localized, "january".localized, "february".localized, "march".localized, "april".localized, "may".localized, "june".localized, "july".localized, "august".localized, "september".localized, "october".localized, "november".localized, "december".localized]
    var statusList = [CRMPickerData]()
    private lazy var crmViewModel = CRMViewModel();
    private var allLeadList = [LeadAll]()
    private var userRole : String?
    private var convertNum : CGFloat = 0
    private var unCovertNum : CGFloat = 0
    private var selectedIndex : Int = 0
    private var filterLeadList = [LeadAll]()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
        setup()
        localized()
        fetchData()
    }
    
    // MARK: - Setup
    private func setup(){
        titleLeadLabel.text = "total lead".localized
        convertedLeadImageView.layer.cornerRadius = (convertedLeadImageView.frame.height / 2)
        unConvertLeadImageView.layer.cornerRadius = (unConvertLeadImageView.frame.height / 2)
        covertedLeadLabel.text = "converted lead".localized
        unConvertedLeadLabel.text = "unconverted lead".localized
        setupCircleBar()
        registerCell()
        // #Picker Delegate & Datesource
        picker.delegate = self
        picker.dataSource = self
        
        // #filterTextField setup
        filterTextField.customizeRegister()
        filterTextField.setDropDownImage()
        filterTextField.inputView = picker
        filterTextField.delegate = self
        
        // #datePickerTextField setup
        datePickerTextField.delegate = self
        datePickerTextField.inputView = self.datePicker
        self.datePicker.setYear(fromYear: 2019, toYear: Calendar.current.component(.year, from: Date()))
        self.datePicker.onDateSelected = {(month, year) in
            self.datePickerTextField.text = "\(self.MONTHS[month]) \(year)"
            self.fetchDataByMonthYear(month: month, year: year)
        }
        let date = Date()
        let calendar = Calendar.current
        let m = calendar.component(.month, from: date)
        let y = calendar.component(.year, from: date)
        self.datePickerTextField.text = "\(self.MONTHS[m]) \(y)"
        
        addDoneButtonOnKeyboard()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        refreshControl?.tintColor = COLOR.RED
        let attributes = [NSAttributedString.Key.foregroundColor: COLOR.RED]
        
        let refreshControlStr = "fetch lead".localized
        refreshControl?.attributedTitle = NSAttributedString(string: refreshControlStr, attributes: attributes as [NSAttributedString.Key : Any])
    }
    
    private func setupCircleBar(){
        if (convertNum + unCovertNum) == 0 {
            circleProgressBarView.isHidden = true
        } else {
            circleProgressBarView.isHidden = false
            circleProgressBarView.maxValue = convertNum + unCovertNum
            circleProgressBarView.value = convertNum
            circleProgressBarView.unitString = "\(unCovertNum)"
            covertedLeadLabel.text = "\(convertNum) " + "converted lead".localized
            unConvertedLeadLabel.text = "\(unCovertNum) " + "unconverted lead".localized
        }
    }
    
    private func registerCell(){
        tableView.register(UINib(nibName: "IndividualLeadTableViewCell", bundle: nil), forCellReuseIdentifier: "IndividualLeadTableViewCellID")
        tableView.register(UINib(nibName: "ManagerLeadTableViewCell", bundle: nil), forCellReuseIdentifier: "ManagerLeadTableViewCellID")
    }
    
    private func localized(){
        
    }
    
    
    // MARK: - Action
    @objc private func fetchData(){
        let date = Date()
        let calendar = Calendar.current
        let m = calendar.component(.month, from: date)
        let y = calendar.component(.year, from: date)
        self.fetchDataByMonthYear(month: m, year: y)
    }
    
    func fetchDataByMonthYear(month m : Int, year y : Int){
        DispatchQueue.main.async {
            
            if let username = AppDelegate.user?.userName {
                self.crmViewModel.fetchAllLeadByUsernameYearMonth(username: username, year: "\(y)", month: "\(m)") { (converted, unConverted, role, leadList) in
                    self.userRole = role
                    self.convertNum = CGFloat(converted)
                    self.unCovertNum = CGFloat(unConverted)
                    self.allLeadList = leadList
                    self.filterLeadList = leadList
                    self.setupCircleBar()
                    self.totalLeadLabel.text = "\(converted+unConverted)"
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .leadStatus) { (list) in
                    self.statusList = [CRMPickerData(0, "overall".localized)]
                    self.statusList.append(contentsOf: list)
                    self.filterTextField.text = self.statusList[self.selectedIndex].name
                }
            }
        }
    }
    
    func customizeNavigationBar(){
        self.navigationItem.title = "CRM".localized
        self.navigationItem.rightBarButtonItem =
        UIBarButtonItem(image: UIImage(named: "add-blue"), style: .plain, target: self, action: #selector(createLead))
    }
    
    @objc func createLead(_ sender : Any){
        let alert = UIAlertController(title: "add lead".localized, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "short form".localized, style: .default, handler: { (action) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CRMShortRegisterViewControllerID") as! CRMShortRegisterViewController
            vc.onDoneBlock = {(status) in
                if status {
                    self.selectedIndex = 0
                    self.fetchData()
                }
            }
            if #available(iOS 13.0, *) {
                self.present(vc, animated: true, completion: nil)
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "long form".localized, style: .default, handler: { (action) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CRMFullRegisterViewControllerID") as! CRMFullRegisterViewController
            vc.onDoneBlock = {(status) in
                if status {
                    self.selectedIndex = 0
                    self.fetchData()
                }
            }
            if #available(iOS 13.0, *) {
                self.present(vc, animated: true, completion: nil)
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action) in
//            print("Cancel hz")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        filterTextField.resignFirstResponder()
        let editStatus = UITableViewRowAction(style: .normal, title: "edit status".localized) { (action, indexPath) in
            let leadId = self.filterLeadList[indexPath.row].leadId
            DispatchQueue.main.async {
                self.crmViewModel.fetchDropDownData(crmPickerEnum: .leadStatus) { (list) in
                    let alert = UIAlertController(title: "change lead status".localized, message: nil, preferredStyle: .alert)
                    for data in list {
                        alert.addAction(UIAlertAction(title: data.name == "Cold" ? "Set Lead to OSP Survey" : data.name, style: .default, handler: { (action) in
                            if data.name == "Cold"{
                                // MARK: - Update to OSP Do Survey
                                let vc = UpdateLeadToOSPViewController(nibName: "UpdateLeadToOSPViewController", bundle: nil)
                                vc.formTitle = "add todo".localized
                                vc.leadId = leadId
                                vc.onSaved = {status in
                                    if status {
                                        self.updateStatus(leadId : leadId, status: data.name)
                                    }
                                }
                                
                                self.sheetController = SheetViewController(controller: vc, sizes: [.percent(0.5), .percent(0.75)])
                                self.sheetController.dismiss(animated: false) { }
                                self.present(self.sheetController, animated: false, completion: nil)
                            } else {
                                self.updateStatus(leadId : leadId, status: data.name)
                            }
                        }))
                    }
                    alert.addAction(UIAlertAction(title: "cancel".localized, style: .destructive, handler: { (action) in
//                        print("cancel")
                    }))
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }

        return [editStatus]
    }
    
    func updateStatus(leadId : String, status : String){
        DispatchQueue.main.async {
            if let username = AppDelegate.user?.userName {
                self.crmViewModel.updateLeadStatus(username: username, leadId: leadId, leadStatus: status) { (message) in
//                    print(message)
                    self.fetchData()
                    self.selectedIndex = 0
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.allLeadList.count == 0 {
//            tableView.setEmptyTableView(UIImage(named: "no_task"), "no lead")
            leadTableHeaderView.isHidden = false
        } else {
            tableView.restore()
            leadTableHeaderView.isHidden = false
        }
        return self.filterLeadList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
    
    // TODO: This isn’t finished yet
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let role = self.userRole {
//            print(role)
            if role == "Sale Person" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualLeadTableViewCellID") as! IndividualLeadTableViewCell
                cell.setData(lead: filterLeadList[indexPath.row])
                cell.id = filterLeadList[indexPath.row].leadId
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ManagerLeadTableViewCellID", for: indexPath) as! ManagerLeadTableViewCell
                cell.setData(lead: filterLeadList[indexPath.row])
                cell.id = filterLeadList[indexPath.row].leadId
//                MARK: - Convert Lead
                cell.convertedLeadAction = { [weak self] (id) in
                    guard let self = self else { return }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckConvertLeadViewControllerID") as! CheckConvertLeadViewController
                    vc.leadId = id
                    vc.onDone = { status in
                        if status {
                            self.fetchData()
                        }
                    }
                    self.sheetController = SheetViewController(controller: vc, sizes: [.percent(0.75), .percent(0.90)])
                    self.present(self.sheetController, animated: false, completion: nil)
//                    self.present(vc, animated: true, completion: nil)
                    
//                    let alert = UIAlertController(title: "convert option".localized, message: nil, preferredStyle: .actionSheet)
//
//                    alert.addAction(UIAlertAction(title: "to organization".localized, style: .default, handler: { (action) in
//                        print("ORG : ", id)
//                    }))
//                    alert.addAction(UIAlertAction(title: "to contact".localized, style: .default, handler: { (action) in
//                        print("CONT : ", id)
//                    }))
//                    alert.addAction(UIAlertAction(title: "both".localized, style: .default, handler: { (action) in
//                        print("Both : ", id)
//                    }))
//                    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action) in
//                        print("Cancel : ", id)
//                    }))
//
//                    self.present(alert, animated: false, completion: nil)
                    
                }
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterTextField.resignFirstResponder()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewLeadDetailViewControllerID") as! ViewLeadDetailViewController
        vc.setLeadId(id: filterLeadList[indexPath.row].leadId)
        if #available(iOS 13.0, *) {
            self.present(vc, animated: true, completion: nil)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}

//  MARK: - PickerDS, Delegate
extension CRMDashboardTableViewController : UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.picker.reloadAllComponents()
        self.picker.selectRow(selectedIndex, inComponent: 0, animated: true)
        self.pickerView(self.picker, didSelectRow: selectedIndex, inComponent: 0)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case filterTextField, datePickerTextField :
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
        filterTextField.inputAccessoryView = toolBar
        filterTextField.autocorrectionType = .no
        
        datePickerTextField.inputAccessoryView = toolBar
        datePickerTextField.autocorrectionType = .no

    }
    
    @objc func donePicker(_ sender : UIBarButtonItem){
        filterTextField.resignFirstResponder()
        datePickerTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusList[row].name == "Cold" ? "Surveying" : statusList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterTextField.text = statusList[row].name
        selectedIndex = row
        if statusList[row].id  == 0 {
            filterLeadList = allLeadList
        } else {
            filterLeadList = allLeadList.filter{$0.status == statusList[row].name}
        }
        self.tableView.reloadData()
    }
    
}
