//
//  ProfileMainTableViewController.swift
//  TurboTech
//
//  Created by sq on 6/12/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileMainTableViewController: UITableViewController {
    
    let sectionTitles = ["information", "department", "language", "logout"]
    
    // MARK: - View
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Information
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    // MARK: - Department
    @IBOutlet weak var departmentLabel: UILabel!
    
    // MARK: - Language
    @IBOutlet weak var languageLabel: UILabel!
    
    // MARK: - Logout
    @IBOutlet weak var logoutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "profile".localized
        setupView()
        setUser(user : AppDelegate.user)
        tableView.reloadData()
    }
    
    func setUser(user : User?){
        if let u = user {
            idLabel.text = u.id
            usernameLabel.text = u.fullName
            positionLabel.text = u.positon.rawValue.localized
            let url = URL(string: u.imageUrl)
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "person.circle.fill"))
        } else {
            UserDefaults.standard.set(false, forKey: "isLogin")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
            self.navigationController?.viewControllers = [vc]
        }
    }
    
    func setupView(){
        tableView.tableFooterView = UITableView()
        tableView.backgroundView = UIImageView(image: UIImage(named: "launchScreen"))
        departmentLabel.text = "department".localized
        languageLabel.text = "curLanguage".localized
        logoutLabel.text = "logout".localized
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2.0
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section].localized
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 1:
            print("Department")
            
//            Another Way to Call Other Storyboard
//        let homeStoryboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
//        let productVC = homeStoryboard.instantiateViewController(withIdentifier: "ProductViewControllerID") as! ProductViewController
//            productVC.setNavigationTitle(title: "Product")
//            self.navigationController?.pushViewController(productVC, animated: true)
//        let department = storyboard?.instantiateViewController(withIdentifier: "DepartmentViewControllerID") as! DepartmentViewController
//        self.navigationController?.pushViewController(department, animated: true)
            
        // MARK: - Seakthong
        switch  AppDelegate.user!.positon {
        case .Admin :
            let departmentStoryboard = UIStoryboard(name: BOARD.DEPARTMENT, bundle: nil)
            let openVC = departmentStoryboard.instantiateViewController(withIdentifier: CONTROLLER.ADMIN) as! AdminTableViewController
            openVC.navigationItem.title = "Admin"
            self.navigationController?.pushViewController(openVC, animated: true)
        case .Finance :
            let departmentStoryboard = UIStoryboard(name: BOARD.DEPARTMENT, bundle: nil)
            let openVC = departmentStoryboard.instantiateViewController(withIdentifier: CONTROLLER.FINANCE) as! FinanceTableViewController
            openVC.navigationItem.title = "Finance"
            self.navigationController?.pushViewController(openVC, animated: true)
        case .HR :
            let departmentStoryboard = UIStoryboard(name: BOARD.DEPARTMENT, bundle: nil)
            let openVC = departmentStoryboard.instantiateViewController(withIdentifier: CONTROLLER.ADMIN) as! AdminTableViewController
            openVC.navigationItem.title = "HR"
            self.navigationController?.pushViewController(openVC, animated: true)
        case .Sale :
            let departmentStoryboard = UIStoryboard(name: BOARD.DEPARTMENT, bundle: nil)
            let openVC = departmentStoryboard.instantiateViewController(withIdentifier: CONTROLLER.SALE) as! SaleTableViewController
            openVC.navigationItem.title = "Sale"
            self.navigationController?.pushViewController(openVC, animated: true)
        }
            
        case 2:
            print("Language")
    
        case 3:
            print("Logout")
            UserDefaults.standard.set(false, forKey: "isLogin")
            AppDelegate.user = nil
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
            self.navigationController?.viewControllers = [loginVC]
        default:
            print("Default")
        }
    }
}
