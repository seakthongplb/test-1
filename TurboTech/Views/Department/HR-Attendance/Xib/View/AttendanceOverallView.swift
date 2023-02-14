//
//  AttendanceOverallView.swift
//  TurboTech
//
//  Created by wo on 7/30/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import FittedSheets

class AttendanceOverallView: UIView {
    
    var target : UIViewController?
    var selectedDate : Date = Date()
    var attendanceReportList = [String : Int]()
    
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var previousDateButton : UIButton!
    @IBOutlet weak var currentDateButton : UIButton!
    @IBOutlet weak var nextDateButton : UIButton!
    
    @IBOutlet weak var morningView : UIView!
    @IBOutlet weak var morningLabel : UILabel!
    @IBOutlet weak var morningPresentLabel : UILabel!
    @IBOutlet weak var morningLateLabel : UILabel!
    @IBOutlet weak var morningPresentButton : UIButton!
    @IBOutlet weak var morningLateButton : UIButton!
    @IBOutlet weak var morningAbsentButton : UIButton!
    @IBOutlet weak var morningPermissionButton : UIButton!
    
    @IBOutlet weak var afternoonView : UIView!
    @IBOutlet weak var afternoonLabel : UILabel!
    @IBOutlet weak var afternoonPresentLabel : UILabel!
    @IBOutlet weak var afternoonLateLabel : UILabel!
    @IBOutlet weak var afternoonPresentButton : UIButton!
    @IBOutlet weak var afternoonLateButton : UIButton!
    @IBOutlet weak var afternoonAbsentButton : UIButton!
    @IBOutlet weak var afternoonPermissionButton : UIButton!
    
    var onReponseDateStatus : ((_ value : Int)->())?
    
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
        
    private func commonInit(){
        Bundle.main.loadNibNamed("AttendanceOverallView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setup()
        self.localized()
    }
    
    override func layoutSubviews() {
        self.morningView.roundCorners(corners: UIRectCorner(arrayLiteral: .allCorners), radius: 8.0)
        self.afternoonView.roundCorners(corners: UIRectCorner(arrayLiteral: .allCorners), radius: 8.0)
    }
    
    func setup(){
        if AttandanceViewModel().getTimeValue() == 0 {
            afternoonLabel.isHidden = true
            afternoonView.isHidden = true
        }
        previousDateButton.addTarget(self, action: #selector(dateButtonPress(_:)), for: .touchUpInside)
        currentDateButton.addTarget(self, action: #selector(dateButtonPress(_:)), for: .touchUpInside)
        nextDateButton.addTarget(self, action: #selector(dateButtonPress(_:)), for: .touchUpInside)
        
        morningPresentButton.addTarget(self, action: #selector(attendanceViewPress(_:)), for: .touchUpInside)
        morningLateButton.addTarget(self, action: #selector(attendanceViewPress(_:)), for: .touchUpInside)
        morningAbsentButton.addTarget(self, action: #selector(attendanceViewPress(_:)), for: .touchUpInside)
        morningPermissionButton.addTarget(self, action: #selector(attendanceViewPress(_:)), for: .touchUpInside)
        
        afternoonPresentButton.addTarget(self, action: #selector(attendanceViewPress(_:)), for: .touchUpInside)
        afternoonLateButton.addTarget(self, action: #selector(attendanceViewPress(_:)), for: .touchUpInside)
        afternoonAbsentButton.addTarget(self, action: #selector(attendanceViewPress(_:)), for: .touchUpInside)
        afternoonPermissionButton.addTarget(self, action: #selector(attendanceViewPress(_:)), for: .touchUpInside)
    }
    
    func localized(){
        self.morningLabel.text = "morning".localized
        self.morningPresentLabel.text = "present".localized
        self.morningLateLabel.text = "late".localized
        self.afternoonLabel.text = "afternoon".localized
        self.afternoonPresentLabel.text = "present".localized
        self.afternoonLateLabel.text = "late".localized
    }
    
    func setData(date : String, mPresent : Int?, mLate : Int?, mAbsent : Int?, mPermission : Int?, aPresent : Int?, aLate : Int?, aAbsent : Int?, aPermission : Int?){
        self.currentDateButton.setTitle(date, for: .normal)
        
        self.morningPresentButton.setTitle("\(mPresent ?? 0)", for: .normal)
        self.morningLateButton.setTitle("\(mLate ?? 0)", for: .normal)
        self.morningAbsentButton.setTitle("\(mAbsent ?? 0) " + "absent".localized, for: .normal)
        self.morningPermissionButton.setTitle("\(mPermission ?? 0) " + "permission".localized, for: .normal)
        
        self.afternoonPresentButton.setTitle("\(aPresent ?? 0)", for: .normal)
        self.afternoonLateButton.setTitle("\(aLate ?? 0)", for: .normal)
        self.afternoonAbsentButton.setTitle("\(aAbsent ?? 0) " + "absent".localized, for: .normal)
        self.afternoonPermissionButton.setTitle("\(aPermission ?? 0) " + "permission".localized, for: .normal)
    }
    
    @objc func dateButtonPress(_ sender : UIButton) {
        var value = 0
        if sender == self.previousDateButton {
            value = -1
        } else if sender == self.nextDateButton {
            value = 1
        }
        if let response = onReponseDateStatus {
            response(value)
        }
    }
    
    @objc func attendanceViewPress(_ sender : UIButton){
        // present morning, late morning, early afternoon, late afternoon early morning, present afternoon
        let pList = (self.target as! PresentAttendanceViewController).attendnacePresentationList
        // absent morning, permission morning, absent afternoon, permission afternoon
        let aList = (self.target as! PresentAttendanceViewController).attendnaceAbsentList
        let vc = PopUpOverallAttendnaceTableViewController(nibName: "PopUpOverallAttendnaceTableViewController", bundle: nil)
        switch sender {
        case self.morningPresentButton, self.afternoonPresentButton, self.morningLateButton, self.afternoonLateButton:
            vc.pData = [pList["present morning"]!, pList["late morning"]!, pList["present afternoon"]!, pList["late afternoon"]!]
            vc.isAbsent = false
        case self.morningAbsentButton, self.afternoonAbsentButton, self.morningPermissionButton, self.afternoonPermissionButton:
            vc.aData = [aList["absent morning"]!, aList["permission morning"]!, aList["absent afternoon"]!, aList["permission afternoon"]!]
            vc.isAbsent = true
        default:
            print("DEF")
            return
        }
        let sc = SheetViewController(controller: vc, sizes: [.percent(0.90)])
        self.target?.present(sc, animated: true, completion: nil)
    }
    
}
