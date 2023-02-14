//
//  ViewLeadDetailViewController.swift
//  TurboTech
//
//  Created by sq on 7/6/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import LGButton
import FittedSheets

class ViewLeadDetailViewController: UIViewController {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var firstLastNameLabel : UILabel!
    @IBOutlet weak var industryCustmerNameLabel : UILabel!
    @IBOutlet weak var editButton : UIButton!
    @IBOutlet weak var primaryPhoneNumberLabel : UILabel!
    @IBOutlet weak var mobilePhoneLabel : UILabel!
    @IBOutlet weak var emailLabel : UILabel!
    @IBOutlet weak var addressLael : UILabel!
    @IBOutlet weak var leadStatusLabel : UILabel!
    @IBOutlet weak var leadSourceLabel : UILabel!
    @IBOutlet weak var historyButton : LGButton!
    
    // MARK: - Data
    private lazy var crmViewModel = CRMViewModel()
    private var lead : Lead?
    private var leadDetail : LeadDetail?
    private var historyList = [LeadHistory]()
    private var leadId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        localized()
        fetchData()
        self.setData(lead: nil)
        profileButton.isUserInteractionEnabled = false
    }
    
    private func localized(){
        self.historyButton.titleString = "history".localized
    }
    
    private func fetchData(){
        DispatchQueue.main.async {
            if let id = self.leadId {
                self.crmViewModel.fetchLeadByLeadId(id: id) { (message, lead) in
                    if let message = message {
                        self.showAndDismissAlert(title: "record not found", message: message, style: .alert, second: 1.5)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.lead = lead
                        self.leadDetail = lead?.leadDetail
                        if let histories = lead?.leadHistories {
                            self.historyList = histories
                        }
                        if let leadDetail = lead?.leadDetail {
                            self.setData(lead: leadDetail)
                        }
                    }
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    public func setLeadId(id : String){
        self.leadId = id
    }
    
    private func setData(lead : LeadDetail?){
        firstLastNameLabel.text = "\(lead?.firstName ?? "no".localized) \(lead?.lastName ?? "name".localized)"
        industryCustmerNameLabel.text = lead?.companyName ?? "no compnay".localized
        primaryPhoneNumberLabel.text = "primary phone".localized + ": " + (lead?.leadPhone ?? "no lead phone".localized)
        mobilePhoneLabel.text = "mobile phone".localized + ": " + (lead?.contactPhone ?? "no contact phone".localized)
        emailLabel.text = "email".localized + ": " + (lead?.contactEmail ?? "no email".localized)
        leadStatusLabel.text = "status".localized + ": " + (lead?.leadStatus ?? "")
        addressLael.text = "address".localized + ": " + (lead?.address ?? "no address".localized)
        leadSourceLabel.text = "lead source".localized + ": " + (lead?.leadSource ?? "no lead source".localized)
    }

    @IBAction func editLeadPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CRMFullRegisterViewControllerID") as! CRMFullRegisterViewController
        guard let lead = self.leadDetail else { return }
        vc.setLead(lead)
        vc.isOldLead = true
        vc.leadId = self.leadId
        if #available(iOS 13.0, *) {
            self.present(vc, animated: true, completion: nil)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func historyPressed(_ sender : Any){
        print("THIS IS WORK")
        print(lead?.leadHistories.count as Any)
        let vc = LeadDetailHistoryViewController(nibName: "LeadDetailHistoryViewController", bundle: nil)
        guard let lead = self.lead else { return }
        vc.historyList = lead.leadHistories
        let sheetController = SheetViewController(controller: vc, sizes: [.percent(0.75), .percent(0.90)])
        sheetController.dismiss(animated: true) {
            
        }
        self.present(sheetController, animated: true, completion: nil)
    }
}
