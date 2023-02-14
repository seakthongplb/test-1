//
//  UpdateLeadToOSPViewController.swift
//  TurboTech
//
//  Created by Mr. iSQ on 12/18/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import iOSDropDown

class UpdateLeadToOSPViewController: UIViewController {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var subjectLabel : UILabel!
    @IBOutlet weak var subjectTextField : UITextField!
    @IBOutlet weak var assignToLabel : UILabel!
    @IBOutlet weak var assignToDropDown : DropDown!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var fromDatePicker : UIDatePicker!
    @IBOutlet weak var toDatePicker : UIDatePicker!
    @IBOutlet weak var saveButton : UIButton!
    var formTitle : String = ""
    var leadId : String!
    
    let ticketViewModel = TicketViewModel()
    let crmViewModel = CRMViewModel()
    var users = [TicketUser]()
    var onSaved : ((_ status : Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.fetchData()
    }
    
    private func setup(){
        self.titleLabel.text = self.formTitle
        self.subjectLabel.text = "subject".localized
        self.assignToLabel.text = "assign to".localized
        self.dateLabel.text = "date".localized
        self.saveButton.setTitle("save".localized, for: .normal)
        self.subjectTextField.delegate = self
    }
    
    private func fetchData(){
        DispatchQueue.main.async {
            self.ticketViewModel.fetchUser(department: DepartmentType.OPD.rawValue) { (users) in
                self.users = users
                var names = [String]()
                users.forEach { (user) in
                    names.append(user.name)
                }
                self.assignToDropDown.delegate = self
                self.assignToDropDown.optionArray = names
                self.assignToDropDown.selectedIndex = 0
                self.assignToDropDown.text = names[0]
                self.assignToDropDown.selectedRowColor = .lightGray
            }
        }
    }
    
    @IBAction func sumbit(_ sender : UIButton){
        print(self.subjectTextField.text ?? "")
        print(self.assignToDropDown.selectedIndex ?? 0)
        print(self.fromDatePicker.date)
        print(self.toDatePicker.date)
        guard let username = AppDelegate.user?.userName else { return }
        if self.users.count == 0 {
            return
        }
        DispatchQueue.main.async {
            // MARK: - POST Insert Lead to ToDo
            self.crmViewModel.postLeadToDo(
                username: username,
                leadId: self.leadId,
                assignTo: "\(self.users[self.assignToDropDown.selectedIndex ?? 0].id)" ,
                subject: self.subjectTextField.text ?? "",
                startDate: self.fromDatePicker.date,
                endDate: self.toDatePicker.date) { (message, status) in
                let vc = UIAlertController(title: "successfully".localized, message: message, preferredStyle: .alert)
                vc.addAction(UIAlertAction(title: "confirm".localized, style: .default){_ in
                    if let onSaved = self.onSaved {
                        onSaved(status)
                    }
                    self.dismiss(animated: false, completion: nil)
                })
                self.present(vc, animated: false){
                }
            }
        }
    }

}

extension UpdateLeadToOSPViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.assignToDropDown :
            return false
        default:
            return true
        }
    }
}
