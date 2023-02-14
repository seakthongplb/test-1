//
//  DepartmentNavigationViewController.swift
//  TurboTech
//
//  Created by sq on 7/15/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class DepartmentNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    func setup(){
        if let user = AppDelegate.user {
            switch user.department {
            case .TOP :
                let vc = storyboard?.instantiateViewController(withIdentifier: "TicketDashboardViewControllerID") as! TicketDashboardViewController
                self.viewControllers = [vc]
            default:
                let vc = storyboard?.instantiateViewController(withIdentifier: "TicketTableViewControllerID") as! TicketTableViewController
                vc.hidesBottomBarWhenPushed = false
                self.viewControllers = [vc]
            }
        } else {
            let st = UIStoryboard(name: "Main", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "ComingSoonViewControllerID") as! ComingSoonViewController
            self.viewControllers = [vc]
        }
    }
}
