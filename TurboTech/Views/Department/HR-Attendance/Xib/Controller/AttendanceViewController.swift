//
//  AttendanceViewController.swift
//  TurboTech
//
//  Created by Sov Sothea on 5/27/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Kingfisher

class AttendanceViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // IBOutlet of AttendanceViewController
    @IBOutlet weak var attendanceProfileImageViewOutlet: UIImageView!
    @IBOutlet weak var lbOverView: UILabel!
    @IBOutlet weak var btnBackAttendanceOutlet: UIButton!
    @IBOutlet weak var lbTopAttendanceOutlet: UILabel!
    @IBOutlet weak var lbBottomAttendanceOutlet: UILabel!
    @IBOutlet weak var attendanceCollectionViewOutlet: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var timeSegmentControl : UISegmentedControl!
    
    // Declare Variable
    var cellSize : CGFloat = 8.0
    var data = [0, 0, 0, 100]
    var dataLabel = ["present".localized, "late".localized, "absence".localized, ""]
    var image = ["tick.circle", "time.circle", "cross.circle", ""]
    let attandanceViewModel = AttandanceViewModel()
    var timeShiftStr : String = "morning"
    
    var attendnacePresentationList = [String : [AttendancePresent]]()
    var attendnaceAbsentList = [String : [AttendanceAbsence]]()
    var attendanceReportList = [String : Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Call Function
        customAttendanceViewController()
        registerCollectionViewCell()
        getDate()
        localized()
        
        setUser(user : AppDelegate.user)
        attendanceCollectionViewOutlet.reloadData()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-dd"
        
        let str = formatter.string(from: Date())
        print("TOT API : ", str)
        let date = str
        DispatchQueue.main.async {
            self.attandanceViewModel.fetchAttendance(today: date) { (presentList, absentList, reportList) in
                print("Working at View -> REPORT")
                print(presentList, absentList, reportList)
                self.attendnaceAbsentList = absentList
                self.attendnacePresentationList = presentList
                self.attendanceReportList = reportList
                if self.attandanceViewModel.getTimeValue() != 0 {
                    self.timeSegmentControl.selectedSegmentIndex = 1
                }
                self.timeSegmentChaned(self.timeSegmentControl)
                self.attendanceCollectionViewOutlet.reloadData()
                reportList.forEach { (key, value) in
                    print(key , value)
                }
            }
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func localized(){
        self.lbTopAttendanceOutlet.text = "hello".localized
        if let username = AppDelegate.user?.fullName {
            self.lbBottomAttendanceOutlet.text = username.localized
        }
        self.lbOverView.text = "overview".localized
        self.timeSegmentControl.setTitle("am".localized, forSegmentAt: 0)
        self.timeSegmentControl.setTitle("pm".localized, forSegmentAt: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.attendanceCollectionViewOutlet.reloadData()
        }
    }
    
    func setUser(user : User?){
        if attandanceViewModel.getTimeValue() == 0 {
            self.timeSegmentControl.isHidden = true
        }
        self.timeSegmentControl.addTarget(self, action: #selector(timeSegmentChaned(_:)), for: .valueChanged)
        if let u = user {
            let url = URL(string: u.imageUrl)
            attendanceProfileImageViewOutlet.kf.setImage(with: url, placeholder: UIImage(named: "attendance-person"))
        }
    }

    
    func registerCollectionViewCell()  {
        attendanceCollectionViewOutlet.register(UINib(nibName: "AttendanceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "attendanceCellItem")
        attendanceCollectionViewOutlet.register(UINib(nibName: "AttendanceReportCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AttendanceReportCollectionViewCellID")
        attendanceCollectionViewOutlet.register(UINib(nibName: "AttendanceAbsentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AttendanceAbsentCollectionViewCellID")
        attendanceCollectionViewOutlet.delegate = self
        attendanceCollectionViewOutlet.dataSource = self
    }
    
    func getDate(){
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        print("\(year):\(month):\(day)")
    }
    
    func customAttendanceViewController() {
        attendanceProfileImageViewOutlet.layer.cornerRadius = attendanceProfileImageViewOutlet.frame.height/2
        attendanceProfileImageViewOutlet.layer.borderWidth = 2
        attendanceProfileImageViewOutlet.layer.borderColor = COLOR.WHITE_SMOKE_GREY.cgColor
        lbTopAttendanceOutlet.textColor = COLOR.COLOR_PRESENT
        lbBottomAttendanceOutlet.textColor = COLOR.COLOR_PRESENT
        
    }
    
    // Action Button
    @IBAction func btnBackAttendance(_ sender: UIButton) {
        sender.pulsate()
        if let nav = navigationController {
            self.navigationController?.isNavigationBarHidden = false
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func timeSegmentChaned(_ sender : UISegmentedControl){
        switch sender.selectedSegmentIndex {
            case 0 :
            timeShiftStr = "morning"
            case 1 :
            timeShiftStr = "afternoon"
            default:
                print("DEF")
        }
        self.attendanceCollectionViewOutlet.reloadData()
    }
}

// MARK: SovSothea
extension AttendanceViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attendanceCellItem", for: indexPath) as! AttendanceCollectionViewCell
        
        if indexPath.row == 0 {
            cell.setData(title: dataLabel[indexPath.row], value: attendnacePresentationList["present \(timeShiftStr)"]?.count ?? 0, imageName: image[indexPath.item])
        } else if indexPath.row == 1 {
            cell.setData(title: dataLabel[indexPath.row], value: attendnacePresentationList["late \(timeShiftStr)"]?.count ?? 0, imageName: image[indexPath.item])
        } else if indexPath.row == 2 {
            cell.setData(title: dataLabel[indexPath.row], value: attendnaceAbsentList["absent \(timeShiftStr)"]?.count ?? 0, imageName: image[indexPath.item])
        }
        
        if cell.frame.maxX > (self.attendanceCollectionViewOutlet.frame.width / 2) {
            if indexPath.item == 3 {
                let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttendanceReportCollectionViewCellID", for: indexPath) as! AttendanceReportCollectionViewCell
                newCell.coverAttendanceViewCellOutlet.backgroundColor = COLOR.BLUE
                newCell.trailingCoverConstraintOutlet.constant = 2 * cellSize
                newCell.leadingCoverConstraintOutlet.constant = cellSize
                newCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
                return newCell
            }
            cell.backgroundCellView.backgroundColor = COLOR.COLOR_LATE
            cell.trailingCoverConstraintOutlet.constant = 2 * cellSize
            cell.leadingCoverConstraintOutlet.constant = cellSize
            
        }
        else {
            if indexPath.item == 2 {
                let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttendanceAbsentCollectionViewCellID", for: indexPath) as! AttendanceAbsentCollectionViewCell
                newCell.mainVIewTrailingContraint.constant = cellSize
                newCell.mainViewLeadingContraint.constant = 2 * cellSize
                newCell.setData(absent: attendanceReportList["absent \(timeShiftStr)"] ?? 0, permission: attendanceReportList["permission \(timeShiftStr)"] ?? 0)
                newCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
                return newCell
            }
            cell.backgroundCellView.backgroundColor = indexPath.item == 0 ? COLOR.BLUE : COLOR.COLOR_ABSENCE
            cell.trailingCoverConstraintOutlet.constant = cellSize
            cell.leadingCoverConstraintOutlet.constant = 2 * cellSize
        }
        // Add GestureRecognizer
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        2 * cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemPerRow : CGFloat = 2
        let itemPerColumn : CGFloat = 2
        let lineSpacing: CGFloat = 2 * cellSize
        let itemSpacing: CGFloat = 0.0
        let size = self.attendanceCollectionViewOutlet.frame.size

        let width = (size.width - (itemPerRow * itemSpacing)) / itemPerRow
        let height = (size.height - (itemPerColumn * lineSpacing)) / itemPerColumn
        return CGSize(width: width, height: height * 1.2)
    }
    
    @objc
    func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.attendanceCollectionViewOutlet)
        let indexPath = self.attendanceCollectionViewOutlet.indexPathForItem(at: location)
        if let index = indexPath {
            print("Got clicked on index: \(index)!")
            switch index.item {
            case 0, 1:
                let presentAttendanceVC = storyboard?.instantiateViewController(withIdentifier: "PresentAttendanceViewControllerID") as! PresentAttendanceViewController
                presentAttendanceVC.modalPresentationStyle = .fullScreen
                presentAttendanceVC.attendnaceType = index.item == 0 ? "present" : "late"
                presentAttendanceVC.attendanceReportList = self.attendanceReportList
                presentAttendanceVC.attendnacePresentationList = self.attendnacePresentationList
                presentAttendanceVC.attendnaceAbsentList = self.attendnaceAbsentList
                presentAttendanceVC.attendanceReportList = self.attendanceReportList
                self.navigationController?.pushViewController(presentAttendanceVC, animated: true)
            case 2:
                let absenceAttendanceVC = storyboard?.instantiateViewController(withIdentifier: "AbsenceAttendanceViewControllerID") as! AbsenceAttendanceViewController
                absenceAttendanceVC.modalPresentationStyle = .fullScreen
                absenceAttendanceVC.attendnaceAbsentList = self.attendnaceAbsentList
                absenceAttendanceVC.attendanceReportList = self.attendanceReportList
                self.attendnaceAbsentList.forEach { (key, value) in
                    print(key, value.count)
                }
                self.navigationController?.pushViewController(absenceAttendanceVC, animated: true)
            case 3 :
                let vc = AttendanceReportViewController(nibName: "AttendanceReportViewController", bundle: nil)
                vc.attendanceReportList = self.attendanceReportList
                vc.attendnaceAbsentList = self.attendnaceAbsentList
                vc.attendancePresentationList = self.attendnacePresentationList
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                print("")
            }
        }
    }
}


    
    
    
    

