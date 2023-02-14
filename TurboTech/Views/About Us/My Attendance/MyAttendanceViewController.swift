//
//  MyAttendanceViewController.swift
//  TurboTech
//
//  Created by wo on 9/4/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class MyAttendanceViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var attendanceViewModel = AttandanceViewModel()
    private var myAttendanceList = [MyAttendanceDetail]()
    private var myAttendanceOverall : MyAttendanceOverall!
    
    @IBOutlet weak var navigationTitle : UILabel!
    
    @IBOutlet weak var myAttendanceView : MyAttendanceView!
    @IBOutlet weak var myAttendanceOverallView : MyAttendanceOverallView!
    @IBOutlet weak var segmentControl : UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        self.navigationTitle.text = "my attendance".localized
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        fetchData()
        addGestureSwapeToSegment()
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(statusSegmentChangedPressed(_:)), for: .valueChanged)
        statusSegmentChangedPressed(self.segmentControl)
        self.segmentControl.setTitle("this week".localized, forSegmentAt: 0)
        self.segmentControl.setTitle("overall".localized, forSegmentAt: 1)
        self.myAttendanceView.target = self
        self.myAttendanceOverallView.target = self
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
        if let uId = AppDelegate.user?.id {
            DispatchQueue.main.async {
                self.attendanceViewModel.fetchMyAttendance(uID: uId) { (list) in
                    self.myAttendanceList = list
                    self.reloadData()
                }
                let date = Date()
                let calendar = Calendar.current
                let m = calendar.component(.month, from: date)
                let y = calendar.component(.year, from: date)
                self.attendanceViewModel.fetchMyAttendance(uID: uId, month: m, year: y) { (overall) in
                    self.myAttendanceOverall = overall
                    self.reloadData()
                }
            }
        }
    }
    
    private func reloadData(){
        myAttendanceView.myAttendanceList = self.myAttendanceList
        myAttendanceView.myAttendanceTableView.reloadData()

        self.myAttendanceOverallView.myAttendanceOverall = self.myAttendanceOverall
        self.myAttendanceOverallView.setData()
    }
    
    private func addGestureSwapeToSegment() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwiped(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleSwiped(_ sender : UISwipeGestureRecognizer){
        segmentControl.selectedSegmentIndex = sender.direction == .right ? segmentControl.selectedSegmentIndex == 0 ? 0 : segmentControl.selectedSegmentIndex - 1 : segmentControl.selectedSegmentIndex == segmentControl.numberOfSegments - 1 ? segmentControl.numberOfSegments - 1 : segmentControl.selectedSegmentIndex + 1
        statusSegmentChangedPressed(segmentControl)
        
    }
    
    @IBAction func statusSegmentChangedPressed(_ sender : UISegmentedControl) {
            switch sender.selectedSegmentIndex {
                case 0 :
                    self.myAttendanceView.isHidden = false
                    self.myAttendanceOverallView.isHidden = true
                case 1 :
                    self.myAttendanceView.isHidden = true
                    self.myAttendanceOverallView.isHidden = false
                default :
                    print("STH")
            }
        }

}
