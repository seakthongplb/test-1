//
//  ERequestDashboardViewController.swift
//  TurboTech
//
//  Created by Mr. iSQ on 3/19/21.
//  Copyright © 2021 TurboTech. All rights reserved.
//

import UIKit

class ERequestDashboardViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var navigationTitlelabel : UILabel!
    @IBOutlet weak var eRequestTableView : UITableView!
    
    var dashboardList : [(id: Int, first: String, second: String, color: UIColor)] =
        [
            (id: 1, first: "Make", second: "Request", color: .white),
            (id: 2, first: "My", second: "Request", color: COLOR.COLOR_PRESENT),
            (id: 3, first: "Approval", second: "Request", color: .white)
            ,(id: 4, first: "All", second: "Requests", color: COLOR.BLUE)
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        self.eRequestTableView.dataSource = self
        self.eRequestTableView.delegate = self
        self.navigationTitlelabel.text = "eRequest".localized
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.eRequestTableView.register(UINib(nibName: "ERequestDashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "ERequestDashboardTableViewCellID")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }

}

extension ERequestDashboardViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dashboardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERequestDashboardTableViewCellID") as! ERequestDashboardTableViewCell
        let data = self.dashboardList[indexPath.row]
        cell.setData(firstLabel: data.first, secondLabel: data.second, color: data.color)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dashboardList[indexPath.row].id {
        case 1 :
//            MARK: - Make Request Form
            print("MAKR REQ FORM")
            let vc = ERequestViewController(nibName: "ERequestViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case 2 :
//            MARK: - Make My Request
            print("MAKR MY REQUEST")
            let vc = OwnRequestViewController(nibName: "OwnRequestViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case 3 :
//            MARK: - Make Approval Request
            print("MAKR APPROVAL REQUEST")
            let vc = ApprovalRequestViewController(nibName: "ApprovalRequestViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        case 4 :
//            MARK: - Make All Requests
            print("MAKR ALL REQUESTS")
            let vc = AllReportViewController(nibName: "AllReportViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("DEF")
        }
    }
    
    
}
