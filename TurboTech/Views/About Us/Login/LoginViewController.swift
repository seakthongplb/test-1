//
//  LoginViewController.swift
//  TurboTech
//
//  Created by Sov Sothea on 5/20/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // IBOutlet of LoginViewController
    @IBOutlet weak var loginProfileImageViewOutlet: UIImageView!
    @IBOutlet weak var txtLoginUsernameOutlet: UITextField!
    @IBOutlet weak var txtLoginPasswordOutlet: UITextField!
    @IBOutlet weak var btnLoginOutlet: UIButton!
    
    // Declare Variable
    var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call Function
        customLoginViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let isLogin = false
        if !isLogin {
            self.dismiss(animated: true) {
            }
        }
    }
    
    func customLoginViewController(){
        txtLoginUsernameOutlet.layer.cornerRadius = SIZE.RADIUS
        txtLoginUsernameOutlet.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: txtLoginUsernameOutlet.frame.height))
        txtLoginUsernameOutlet.leftViewMode = .always
        txtLoginUsernameOutlet.shadowStyle(radius: 6, color: .black, offset: CGSize(width: -0.5, height: 4), opacity: 1)
        
        txtLoginPasswordOutlet.layer.cornerRadius = SIZE.RADIUS
        txtLoginPasswordOutlet.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: txtLoginPasswordOutlet.frame.height))
        txtLoginPasswordOutlet.leftViewMode = .always
        txtLoginPasswordOutlet.shadowStyle(radius: 6, color: .black, offset: CGSize(width: -0.5, height: 4), opacity: 1)
        
        loginProfileImageViewOutlet.layer.cornerRadius = loginProfileImageViewOutlet.frame.height/2
        loginProfileImageViewOutlet.layer.borderWidth = 2
        loginProfileImageViewOutlet.layer.borderColor = COLOR.RED.cgColor
        
        btnLoginOutlet.layer.cornerRadius = SIZE.RADIUS
        btnLoginOutlet.layer.borderWidth = 2
        btnLoginOutlet.layer.borderColor = COLOR.WHITE.cgColor
        btnLoginOutlet.tintColor = COLOR.RED
        btnLoginOutlet.shadowStyle(radius: 6, color: .black, offset: CGSize(width: -0.5, height: 4), opacity: 1)
    }
    
    // Action Button
    @IBAction func btnLogin(_ sender: UIButton) {
        txtLoginUsernameOutlet.layer.borderColor = UIColor.gray.cgColor
        txtLoginPasswordOutlet.layer.borderColor = UIColor.gray.cgColor
        
        guard let username = txtLoginUsernameOutlet.text, let password = txtLoginPasswordOutlet.text else {return}
        
        if username == "" || password == "" {
            if username == "" {
                txtLoginUsernameOutlet.layer.borderColor = UIColor.red.cgColor
            }
            if password == "" {
                txtLoginPasswordOutlet.layer.borderColor = UIColor.red.cgColor
            }
            print(username, password)
            return
        }
        
        print(username, password)
        
        DispatchQueue.main.async {
            sender.pulsate()
            self.loginViewModel.userLogin(username: username, password: password) { (isSucceed, user)  in
                
                print(isSucceed)
                
                if !isSucceed {
                    self.showAndDismissAlert(title: "please try again".localized, message: "", style: .alert, second: 1.5)
                    return
                } else {
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    AppDelegate.user = user
                    UserDefaults.standard.set(username, forKey: "curUsername")
                    UserDefaults.standard.set(password, forKey: "curPassword")
//                    if let u = user {
//                        let encodedData : Data = NSKeyedArchiver.archivedData(withRootObject: [u])
//                        print("Console Data : ", encodedData)
//
//                        UserDefaults.standard.set(encodedData, forKey: "curUser")
//                        UserDefaults.standard.synchronize()
//                    }
//
//
//                    let decoded = UserDefaults.standard.data(forKey: "curUser")
//                    if let decode = decoded {
//                        print("work decode")
//                        print(try! NSKeyedUnarchiver.unarchivedObject(ofClass: User.self, from: decode)!.id)
//                    } else {
//                        print("not work decode")
//                        UserDefaults.standard.set(false, forKey: "isLogin")
//                    }
                    
                    let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileMainTableViewControllerID") as! ProfileMainTableViewController
                    self.navigationController?.viewControllers = [profileVC]
                }
                
//                if user.id == "0" {
//                    print("Wrong Login")
//                    AppDelegate.isLogin = true
//                    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewControllerID") as! ProfileViewController
//                    self.navigationController?.viewControllers = [newViewController]
//                }
//                else {
//                    print("Login Success")
//                    self.dismiss(animated: false) {
//
//                    }
//                }
            }
        }
    }
}




