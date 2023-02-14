//
//  AddTicketViewController.swift
//  TurboTech
//
//  Created by sq on 7/16/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class AddTicketViewController: UIViewController {
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var ticketHelpDeskInsertionView : TicketHelpDeskInsertionView!
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var createButton : UIButton!
    
    var ticketViewModel = TicketViewModel()
    var ticket : TicketNotification?
    var dept : String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        localized()
        fetchData()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        createButton.addTarget(self, action: #selector(createTicketPressed(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelPressed(_:)), for: .touchUpInside)
        ticketHelpDeskInsertionView.target = self
        self.ticketHelpDeskInsertionView.ticket = ticket
        self.ticketHelpDeskInsertionView.dept = dept
        self.createButton.setTitle(self.ticket != nil ? "update".localized : "create".localized, for: .normal)
        self.cancelButton.setTitle("cancel".localized, for: .normal)
        setLeftNavigationItem()
    }
    
    private func setLeftNavigationItem(){
        
        let rNavView = UIView(frame: CGRect(x: 0, y: 0, width: 40,height: 40))
        
        let notificationBtn = UIButton(frame: CGRect(x: 0,y: 0, width: 40, height: 40))
        notificationBtn.setImage(UIImage(named: "ticket-history"), for: .normal)
        notificationBtn.tintColor = .white
        notificationBtn.contentVerticalAlignment = .fill
        notificationBtn.contentHorizontalAlignment = .fill
        notificationBtn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        notificationBtn.addTarget(self, action: #selector(self.didTapHistoryButton), for: .touchUpInside)
        rNavView.addSubview(notificationBtn)

        let rightBarButton = UIBarButtonItem(customView: rNavView)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc
    func didTapHistoryButton(){
        guard let ticketId = self.ticket?.ticket_id else { return }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TicketHistoryTableViewControllerID") as! TicketHistoryTableViewController
        vc.ticketId = ticketId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func localized() {
        self.navigationItem.title = self.ticket == nil ? "create new ticket".localized : "update ticket".localized
    }
    
    private func fetchData() {
        
    }
    
    @objc func cancelPressed(_ sender : Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func createTicketPressed(_ sender : Any) {
        guard let ticket = self.ticketHelpDeskInsertionView.getTicket() else { return }
        DispatchQueue.main.async {
            self.ticketViewModel.postTicket(ticket: ticket) { (status, message) in
                let alert = UIAlertController(title: "\(self.ticket == nil ? "create new ticket".localized : "update ticket".localized)", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "confirm".localized, style: .default, handler: { (action) in
                    alert.dismiss(animated: true) {
                        if status {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }))
                self.present(alert, animated: true) {
                    
                }
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset : UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardSize.size.height
            scrollView.contentInset = contentInset
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
}
