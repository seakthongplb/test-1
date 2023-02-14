//
//  MyAttendanceOverallView.swift
//  
//
//  Created by wo on 9/7/20.
//

import UIKit
import FittedSheets

class MyAttendanceOverallView: UIView {
    
    var target : UIViewController?
    var myAttendanceOverall : MyAttendanceOverall?
    
    @IBOutlet weak var chooseDateTextField : UITextField!
    @IBOutlet weak var earlyLabel : UILabel!
    @IBOutlet weak var lateLabel : UILabel!
    @IBOutlet weak var absentLabel : UILabel!
    
    @IBOutlet weak var earlyShiftLabel : UILabel!
    @IBOutlet weak var lateShiftLabel : UILabel!
    @IBOutlet weak var absentShiftLabel : UILabel!
    
    @IBOutlet weak var overallView : UIView!
    @IBOutlet weak var earlyButton : UIButton!
    @IBOutlet weak var lateButton : UIButton!
    @IBOutlet weak var absentButton : UIButton!
    
    var picker = MonthYearPickerView()
    let MONTHS = ["month".localized, "january".localized, "february".localized, "march".localized, "april".localized, "may".localized, "june".localized, "july".localized, "august".localized, "september".localized, "october".localized, "november".localized, "december".localized]

    
    
    @IBOutlet weak var contentView : UIView!
    
    override init(frame: CGRect) {
        // Using CustomView in Code
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Using customView in IB
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        setup()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("MyAttendanceOverallView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setup()
    }
    
    private func setup(){
        self.overallView.roundCorners(corners: UIRectCorner([.allCorners]), radius: SIZE.RADIUS_CARD)
        fetchData()
        setData()
        let date = Date()
        let calendar = Calendar.current
        let m = calendar.component(.month, from: date)
        let y = calendar.component(.year, from: date)
        self.chooseDateTextField.text = "\(self.MONTHS[m]) \(y)"
        self.chooseDateTextField.delegate = self
        self.chooseDateTextField.inputView = picker
        picker.setYear(fromYear: 2018, toYear: 2022)
        picker.onDateSelected = {(month, year) in
            if year > y { return } else if year == y && month > m { return }
            self.chooseDateTextField.text = "\(self.MONTHS[month]) \(year)"
            if let uId = AppDelegate.user?.id {
                DispatchQueue.main.async {
                    let attendanceViewModel = AttandanceViewModel()
                    attendanceViewModel.fetchMyAttendance(uID: uId, month: month, year: year) { (overall) in
                        self.myAttendanceOverall = overall
                        self.setData()
                    }
                }
            }
        }
        addDoneButtonOnKeyboard()
    }
    
    private func fetchData(){
        
    }
    
    func setData(){
        self.earlyLabel.text = "early".localized
        self.lateLabel.text = "late".localized
        self.absentLabel.text = "absent".localized
        
        self.earlyShiftLabel.text = "shift".localized
        self.lateShiftLabel.text = "shift".localized
        self.absentShiftLabel.text = "shift".localized
        guard let myAttendanceOverall = self.myAttendanceOverall else { return }
        self.earlyButton.setTitle("\(myAttendanceOverall.present)", for: .normal)
        self.lateButton.setTitle("\(myAttendanceOverall.late)", for: .normal)
        self.absentButton.setTitle("\(myAttendanceOverall.absent)", for: .normal)
    }
    
    
    @IBAction func earlyTouched(_ sender : UIButton){
        print("Early")
        let vc = MyAttendancePopUpViewController(nibName: "MyAttendancePopUpViewController", bundle: nil)
        guard let list = self.myAttendanceOverall?.myAttendanceDetails else { return }
        vc.myAttendanceList = list
        let sheetController = SheetViewController(controller: vc, sizes: [.percent(0.75), .percent(0.90)])
        sheetController.dismiss(animated: true) {
            
        }
        self.target?.present(sheetController, animated: true, completion: nil)
    }
}

extension MyAttendanceOverallView : UITextFieldDelegate {
    @objc func donePicker(_ sender : UIBarButtonItem){
        self.chooseDateTextField.resignFirstResponder()
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
        self.chooseDateTextField.inputAccessoryView = toolBar
    }
}
