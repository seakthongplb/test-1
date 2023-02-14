//
//  SaleTableViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class SaleTableViewController: UITableViewController {
    var departmentList = [Department]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        tableView.register(UINib(nibName: "SubMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SubMenuCellID")
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "launchScreen")!)
    }
    
    func setData() {
//        let str = "https://www.turbotech.com/storages/assets/img/img_mobile/15900490041355968.png"
//        print("Here Sale")
        departmentList.append(Department(id: 0, name: "saleProduct".localized, image: "product-icon", sale: .Product))
        departmentList.append(Department(id: 1, name: "salePop".localized, image: "pop-icon", sale: .Pop))
        departmentList.append(Department(id: 2, name: "saleDevice".localized, image: "device-icon", sale: .Device))
        departmentList.append(Department(id: 3, name: "saleCrm".localized, image: "crm-icon", sale: .CRM))
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
        switch departmentList[indexPath.row].sale! {
        case .Product :
            let homeSB = UIStoryboard(name: BOARD.HOME, bundle: nil)
            let openVC = homeSB.instantiateViewController(withIdentifier: CONTROLLER.PRODUCT) as! ProductViewController
            openVC.setNavigationTitle(title: departmentList[indexPath.row].name)
            self.navigationController?.pushViewController(openVC, animated: true)
        case .Device :
//            print("Deivice")
            let homeSB = UIStoryboard(name: BOARD.HOME, bundle: nil)
            let openVC = homeSB.instantiateViewController(withIdentifier: CONTROLLER.DEVICE) as! DeviceTableViewController
            openVC.navigationItem.title = departmentList[indexPath.row].name
            self.navigationController?.pushViewController(openVC, animated: true)
        case .Pop :
//            print("POP")
            let homeSB = UIStoryboard(name: BOARD.HOME, bundle: nil)
            let locationVC = homeSB.instantiateViewController(withIdentifier: CONTROLLER.POP_LOCATION) as! PopLocationViewController
            locationVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(locationVC, animated: true)
        case .CRM :
//            print("CRM")
            let crmVC = self.storyboard?.instantiateViewController(withIdentifier: "CRMDashboardTableViewControllerID") as! CRMDashboardTableViewController
            crmVC.modalPresentationStyle = .fullScreen
            crmVC.navigationItem.title = departmentList[indexPath.row].name
            self.navigationController?.pushViewController(crmVC, animated: true)
        }
    }
}
