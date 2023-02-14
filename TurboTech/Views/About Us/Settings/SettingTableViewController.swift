//
//  SettingTableViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var languageImageView: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var chnagePasswordImageView: UIImageView!
    @IBOutlet weak var changePasswordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        localize()
    }
    
    private func localize(){
        languageLabel.text = "curLanguage".localized
        changePasswordLabel.text = "change password".localized
        self.navigationItem.title = "setting".localized
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLanguageViewControllerID") as! ChangeLanguageViewController
            vc.onDoneBlock = {
                self.localize()
            }
            self.present(vc, animated: true, completion: nil)
        } else if indexPath.row == 1 && indexPath.section == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewControllerID") as! ChangePasswordViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    

}
