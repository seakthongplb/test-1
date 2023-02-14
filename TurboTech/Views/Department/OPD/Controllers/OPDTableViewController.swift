//
//  OPDTableViewController.swift
//  TurboTech
//
//  Created by wo on 9/11/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class OPDTableViewController: UITableViewController {
    var departmentList = [Department]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        tableView.register(UINib(nibName: "SubMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SubMenuCellID")
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "launchScreen")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setData() {
        guard let user = AppDelegate.user else { self.dismiss(animated: true, completion: nil); return}
        if(user.position == .hrAndAdmin || user.positionCRM == .hrAndAdmin){
            departmentList.append(Department(id: 2, name: "attendance".localized, image: "attendance-dept", opd: .ATTENDANCE))
        } else {
            departmentList.append(Department(id: 3, name: "saleCrm".localized, image: "crm-icon", opd: .CRM))
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
        switch departmentList[indexPath.row].opd! {
        case .CRM :
            let departmentStoryboard = UIStoryboard(name: BOARD.DEPARTMENT, bundle: nil)
            let crmVC = departmentStoryboard.instantiateViewController(withIdentifier: "CRMDashboardTableViewControllerID") as! CRMDashboardTableViewController
            crmVC.modalPresentationStyle = .fullScreen
            crmVC.navigationItem.title = departmentList[indexPath.row].name
            self.navigationController?.pushViewController(crmVC, animated: true)
        case .ATTENDANCE :
            let attendanceStoryboard = UIStoryboard(name: BOARD.ABOUTUS, bundle: nil)
            let attendance = attendanceStoryboard.instantiateViewController(withIdentifier: CONTROLLER.ATTENDANCE) as! AttendanceViewController
            self.navigationController?.pushViewController(attendance, animated: true)
        }
    }
}
