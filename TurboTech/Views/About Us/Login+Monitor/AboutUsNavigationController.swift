//
//  ViewController.swift
//  TurboTech
//
//  Created by Sov Sothea on 5/29/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class AboutUsNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoginSucceed(UserDefaults.standard.bool(forKey: "isLogin"))
    }
    
    func isLoginSucceed(_ status : Bool){
        if status {
            let newViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileMainTableViewControllerID") as! ProfileMainTableViewController
            self.viewControllers = [newViewController]
        } else {
            let newViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
            self.viewControllers = [newViewController]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isLoginSucceed(UserDefaults.standard.bool(forKey: "isLogin"))
    }
}
