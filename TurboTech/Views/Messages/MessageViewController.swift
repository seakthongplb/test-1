//
//  MessageViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changed"), object: nil)
        
    }
    
    @IBAction func btn(_ sender: Any) {
        
        let department = UIStoryboard(name: BOARD.DEPARTMENT, bundle: nil)
        let crmVC = department.instantiateViewController(withIdentifier: "TicketTableViewControllerID") as! TicketTableViewController
        crmVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(crmVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localized()
    }
    
    func localized(){
        label.text = "Coming Soon".localized
    }
    
    @objc
    func hello(_ : UIButton){
//        print("Hello")
        
    }
    
    @objc
    func changeLanguage(){
    }
}
