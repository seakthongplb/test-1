//
//  PopDetailViewController.swift
//  TurboTech
//
//  Created by wo on 7/21/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PopDetailViewController: UIViewController {
    @IBOutlet weak var popTitleLabel : UILabel!
    @IBOutlet weak var popNameLabel : UILabel!
    @IBOutlet weak var popContactNameLabel : UILabel!
    @IBOutlet weak var popContactPhoneLabel : UILabel!
    @IBOutlet weak var popCoreLabel : UILabel!
    @IBOutlet weak var popCustomerNumberLabel : UILabel!
    @IBOutlet weak var popNameDataLabel : UILabel!
    @IBOutlet weak var popContactNameDataLabel : UILabel!
    @IBOutlet weak var popContactPhoneDataLabel : UILabel!
    @IBOutlet weak var popCoreDataLabel : UILabel!
    @IBOutlet weak var popCustomerNumberDataLabel : UILabel!
    @IBOutlet weak var segmentControl : UISegmentedControl!
    @IBOutlet weak var tableView : UITableView!
    private var popInnerDetail : PopInnerDetail?
    private var activePopInnerList = [PopInner]()
    var id : Int?
    var popName : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        self.localized()
        self.fetchData()
        self.registerCell()
        self.addGestureSwapeToSegment()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchData(){
        DispatchQueue.main.async {
            let saleViewModel = SaleViewModel()
            guard let id = self.id else { return }
            saleViewModel.fetchPopInnerDetail(popId: "\(id)") { (result) in
                self.popInnerDetail = result
                self.setData()
            }
        }
    }
    
    private func setData(){
        self.popNameDataLabel.text = self.popName
        self.popContactNameDataLabel.text = self.popInnerDetail?.popContact.contactName
        self.popContactPhoneDataLabel.text = self.popInnerDetail?.popContact.phone
        self.popCoreDataLabel.text = self.popInnerDetail?.popContact.core
        self.popCustomerNumberDataLabel.text = self.popInnerDetail?.popContact.customer
        self.statusSegmentChangedPressed(self.segmentControl)
    }
    
    private func localized(){
        self.popNameLabel.text = "pop name".localized
        self.popContactNameLabel.text = "contact name".localized
        self.popContactPhoneLabel.text = "phone number".localized
        self.popCoreLabel.text = "core".localized
        self.popCustomerNumberLabel.text = "customer".localized
    }
    
    private func registerCell(){
        tableView.register(UINib(nibName: "PopDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "PopDetailTableViewCellID")
        tableView.register(UINib(nibName: "PopDetailCustomerTableViewCell", bundle: nil), forCellReuseIdentifier: "PopDetailCustomerTableViewCellID")
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
        segmentControl.selectedSegmentIndex = sender.direction == .right ? segmentControl.selectedSegmentIndex == 0 ? 0 : segmentControl.selectedSegmentIndex - 1 : segmentControl.selectedSegmentIndex == segmentControl.numberOfSegments - 1 ? segmentControl.numberOfSegments - 1 : segmentControl.selectedSegmentIndex + 1
        statusSegmentChangedPressed(segmentControl)
        
    }
    
    @IBAction func statusSegmentChangedPressed(_ sender : UISegmentedControl) {
        guard let data = self.popInnerDetail else { return }
        print("#001")
        self.activePopInnerList = sender.selectedSegmentIndex == 0 ? data.popProduct : data.popCustomer
        print("#002")
        self.reloadData()
    }
    
    func reloadData(){
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                print("#003")
                self.tableView.reloadData()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DispatchQueue.main.async(execute: {
                print("#004")
                self.tableView.reloadData()
            })
        }
    }
}

extension PopDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        popDetailList.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("#005")
        return activePopInnerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentControl.selectedSegmentIndex {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PopDetailTableViewCellID") as! PopDetailTableViewCell
                cell.setData(activePopInnerList[indexPath.row] as! PopProduct)
                return cell
            case 1 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "PopDetailCustomerTableViewCellID") as! PopDetailCustomerTableViewCell
                cell.setData(activePopInnerList[indexPath.row] as! PopCustomer)
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        60
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        popDetailList[section].productLabel + " : " + "\(popDetailList[section].qty)" + " " + popDetailList[section].unit
//    }
    
    
}
 
