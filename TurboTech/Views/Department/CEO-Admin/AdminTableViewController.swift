//
//  AdminTableViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class AdminTableViewController: UITableViewController {
    
    var departmentList = [Department]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        tableView.register(UINib(nibName: "SubMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SubMenuCellID")
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "launchScreen")!)
    }
    
    // MARK: - Manage Position Here
    func setData() {
//        print("Here Admin")
        guard let user = AppDelegate.user else { self.dismiss(animated: true, completion: nil); return}
        if(user.position == .hrAndAdmin || user.positionCRM == .hrAndAdmin){
            departmentList.append(Department(id: 2, name: "attendance".localized, image: "attendance-dept", department: .OPD))
        } else {
            departmentList.append(Department(id: 0, name: "business".localized, image: "business-dept", department: .BSD))
            departmentList.append(Department(id: 1, name: "finance".localized, image: "finance-dept", department: .FND))
            departmentList.append(Department(id: 2, name: "attendance".localized, image: "attendance-dept", department: .OPD))
    //        departmentList.append(Department(id: 3, name: "operation".localized, image: "operation-dept", department: .operation))
            departmentList.append(Department(id: 4, name: "ict".localized, image: "ict-dept", department: .ITD))
    //        departmentList.append(Department(id: 5, name: "audit".localized, image: "audit-dept", department: .audit))
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        departmentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubMenuCellID") as! SubMenuTableViewCell
        cell.setData(department: departmentList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.frame.size.height
        if (height < 600){
            return height / SIZE.NUM_ROW_PRO_SMALL
        }
        else if (height < 800) {
            return height / SIZE.NUM_ROW_PRO_MEDIUM
        }
        else {
            return height / SIZE.NUM_ROW_PRO_LARGE
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch departmentList[indexPath.row].department! {
        case .BSD :
            let openVC = storyboard?.instantiateViewController(withIdentifier: CONTROLLER.SALE) as! SaleTableViewController
//            print("\(departmentList[indexPath.row].name)")
            openVC.navigationItem.title = departmentList[indexPath.row].name
            self.navigationController?.pushViewController(openVC, animated: true)
        case .FND :
//            let main = UIStoryboard(name: "Main", bundle: nil)
//            let vc = main.instantiateViewController(withIdentifier: "ComingSoonViewControllerID") as! ComingSoonViewController
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinanceTableViewControllerID") as! FinanceTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case  .OPD:
            // MARK: - @Sothea Attendance Screen
            print("Attendance")
            let attendanceStoryboard = UIStoryboard(name: BOARD.ABOUTUS, bundle: nil)
            let attendance = attendanceStoryboard.instantiateViewController(withIdentifier: CONTROLLER.ATTENDANCE) as! AttendanceViewController
            self.navigationController?.pushViewController(attendance, animated: true)
        case .TOP:
            print("Owner hz Dear")
        case .ITD:
            let main = UIStoryboard(name: "Main", bundle: nil)
            let vc = main.instantiateViewController(withIdentifier: "ComingSoonViewControllerID") as! ComingSoonViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case .NONE :
            self.dismiss(animated: true, completion: nil)
        }
    }

}
