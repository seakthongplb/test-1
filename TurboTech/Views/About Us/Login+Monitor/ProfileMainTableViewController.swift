//
//  ProfileMainTableViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileMainTableViewController: UITableViewController {
    
    let sectionTtiles = ["information", "department", "about us", "setting", "logout"]
    
    // MARK: - View
    @IBOutlet weak var outerProfileImageView : UIView!
    @IBOutlet weak var innerProfileImageView : UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Information
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var myAttendanceLabel : UILabel!
    @IBOutlet weak var eRequestTitleLabel : UILabel!
    
    // MARK: - Department
    @IBOutlet weak var departmentLabel: UILabel!
    
    // MARK: - About Us
    @IBOutlet weak var aboutUsLabel : UILabel!
    
    // MARK: - Language
    @IBOutlet weak var settingLabel: UILabel!
    
    // MARK: - Logout
    @IBOutlet weak var logoutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()
        setupView()
        setUser(user : AppDelegate.user)
        tableView.reloadData()
    }
    
    private func localize(){
        self.navigationItem.title = "profile".localized
        self.tabBarController?.tabBar.items![0].title = "home".localized
        self.tabBarController?.tabBar.items![1].title = "location".localized
        self.tabBarController?.tabBar.items![2].title = "message".localized
        self.tabBarController?.tabBar.items![3].title = "profile".localized
    }
    
    func setUser(user : User?){
        if let u = user {
            print(u.department, u.position, u.positionCRM, u.departmentCRM)
            idLabel.text = u.id
            usernameLabel.text = u.fullName
            positionLabel.text = u.position != .none ? u.position.rawValue.localized : u.positionCRM != .none ? u.positionCRM.rawValue.localized : ""
            let url = URL(string: u.imageUrl)
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "user-circle"))
        } else {
            // MARK: - TODO - Login
//            if UserDefaults.standard.bool(forKey: "isLogin") {
//                reLogin()
//            } else {
                UserDefaults.standard.set(false, forKey: "isLogin")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
                self.navigationController?.viewControllers = [vc]
//            }
        }
    }
    
    func reLogin(){
//      MARK: - Check Connection Again
        InternetConnection.shared.checkConnection(self) { (status) in
            if status {
//              Login Successfully
            } else {
                self.reLogin()
            }
        }
    }
    
    func setupView(){
        tableView.tableFooterView = UITableView()
//        tableView.backgroundView = UIImageView(image: UIImage(named: "launchScreen"))
        myAttendanceLabel.text = "my attendance".localized
        eRequestTitleLabel.text = "eRequest".localized
        departmentLabel.text = "department".localized
        aboutUsLabel.text = "strategic posture".localized
        settingLabel.text = "setting".localized
        logoutLabel.text = "logout".localized
        outerProfileImageView.setColorGradient(colorOne: .cyan, colorTwo: .systemPink)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        outerProfileImageView.roundCorners(corners: [.allCorners], radius: outerProfileImageView.frame.size.width)
        innerProfileImageView.roundCorners(corners: [.allCorners], radius: innerProfileImageView.frame.size.width)
        imageView.roundCorners(corners: [.allCorners], radius: imageView.frame.size.width)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTtiles[section].localized
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let section = indexPath.section
            switch section {
            case 0 :
                if indexPath.row == 3 {
                    let vc = MyAttendanceViewController(nibName: "MyAttendanceViewController", bundle: nil)
                    vc.navigationItem.title = "my attendance".localized
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if indexPath.row == 4 {
//                    MARK: - E Request
                    let vc = ERequestDashboardViewController(nibName: "ERequestDashboardViewController", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 1:
//                print("Department")
                print("#001 : ", AppDelegate.user!.department)
                // MARK: - Checking The Department Module
                let department = AppDelegate.user!.departmentCRM == .NONE ? AppDelegate.user!.departmentCRM : AppDelegate.user!.department
                
                switch department {
                case .TOP :
                    let departmentStoryboard = UIStoryboard(name: BOARD.DEPARTMENT, bundle: nil)
                    let openVC = departmentStoryboard.instantiateViewController(withIdentifier: CONTROLLER.ADMIN) as! AdminTableViewController
                    guard let u = AppDelegate.user else { return }
                    openVC.navigationItem.title = u.position != .none ? u.position.rawValue.localized : u.positionCRM != .none ? u.positionCRM.rawValue.localized : ""
                    self.navigationController?.pushViewController(openVC, animated: true)
                    
                case .FND :
                    let departmentStoryboard = UIStoryboard(name: BOARD.DEPARTMENT, bundle: nil)
                    let openVC = departmentStoryboard.instantiateViewController(withIdentifier: CONTROLLER.FINANCE) as! FinanceTableViewController
                    openVC.navigationItem.title = "Finance".localized
                    self.navigationController?.pushViewController(openVC, animated: true)
                    
                case .OPD :
                    let openVC = OPDTableViewController.init(nibName: "OPDTableViewController", bundle: nil)
                    openVC.navigationItem.title = "OPD".localized
                    self.navigationController?.pushViewController(openVC, animated: true)
                    
                case .BSD :
                    let departmentStoryboard = UIStoryboard(name: BOARD.DEPARTMENT, bundle: nil)
                    let openVC = departmentStoryboard.instantiateViewController(withIdentifier: CONTROLLER.SALE) as! SaleTableViewController
                    openVC.navigationItem.title = "Sale".localized
                    self.navigationController?.pushViewController(openVC, animated: true)
                    
                case .ITD :
                    break
                case .NONE :
                    break
                }
            case 2:
//                print("About us")
                let aboutusVC = storyboard?.instantiateViewController(withIdentifier: "StrategicPostureViewControllerID") as! StrategicPostureViewController
                aboutusVC.navigationItem.title = "strategic posture".localized
                aboutusVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(aboutusVC, animated: true)
                
            case 3:
//                print("Setting")
                let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingTableViewControllerID") as! SettingTableViewController
                settingVC.navigationItem.title = "setting".localized
                settingVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(settingVC, animated: true)
            case 4:
//                print("Logout")
                let alert = UIAlertController(title: "do you want to logout?".localized, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action) in
//                    print("Cancel")
                }))
                alert.addAction(UIAlertAction(title: "logout".localized, style: .destructive, handler: { (action) in
//                    print("logout")
                    User.resetUser()
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
                    self.navigationController?.viewControllers = [loginVC]
                }))
                self.present(alert, animated: true, completion: nil)
            default:
                print("Default")
                
            }
        }

}
