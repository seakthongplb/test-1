//
//  TicketTableViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import SwipeCellKit

class TicketTableViewController: UITableViewController {

    @IBOutlet weak var segmentControl : UISegmentedControl!
    
    var ticketList = [TicketNotification]()
    var ticketNotificationList = [TicketNotification]()
    var ticketNotificationList0 = [TicketNotification]()
    var ticketNotificationList1 = [TicketNotification]()
    var ticketNotificationList2 = [TicketNotification]()
    var ticketNotificationList3 = [TicketNotification]()
    var activeTicketNotificationList = [TicketNotification]()
    lazy var ticketViewModel = TicketViewModel()
    var dept : String?
    var month : Int!
    var year : Int!
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @objc private func fetchData(){
        
        DispatchQueue.main.async {
            guard let user = AppDelegate.user, let m = self.month, let y = self.year else { return }
            
            if let deptName = self.dept {
                self.ticketViewModel.getTicketByDeptYearMonth(deptName, y, m) { (list) in
                    self.ticketNotificationList = list
                    self.refreshControl?.endRefreshing()
                    self.statusSegmentChangedPressed(self.segmentControl)
                }
            }
            
            if user.department != .TOP {
                self.ticketViewModel.getTicketNotification(user.userName, y, m) { (list) in
                    self.ticketNotificationList = list
                    self.refreshControl?.endRefreshing()
                    self.statusSegmentChangedPressed(self.segmentControl)
                }
            }
        }
    }
    
    private func setup(){
        self.navigationItem.title = "ticket".localized
        registerCell()
        addRightButton()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        refreshControl?.tintColor = COLOR.RED
        
        let attributes = [NSAttributedString.Key.foregroundColor: COLOR.RED]
        
        let refreshControlStr = "fetch ticket".localized
        refreshControl?.attributedTitle = NSAttributedString(string: refreshControlStr, attributes: attributes as [NSAttributedString.Key : Any])
        addGestureSwapeToSegment()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGesture:)))
        longPressGesture.minimumPressDuration = 0.5
        self.tableView.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        if indexPath == nil {
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            let alert = UIAlertController(title: "change status".localized, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "open".localized, style: .default, handler: { (action) in
                self.updateTicketStatus("Open", indexPath!.row)
            }))
            
            alert.addAction(UIAlertAction(title: "in progress".localized, style: .default, handler: { (action) in
                self.updateTicketStatus("In Progress", indexPath!.row)
            }))
            
            alert.addAction(UIAlertAction(title: "wait for resposne".localized, style: .default, handler: { (action) in
                self.updateTicketStatus("Wait For Response", indexPath!.row)
            }))
            
            alert.addAction(UIAlertAction(title: "closed".localized, style: .default, handler: { (action) in
                self.updateTicketStatus("Closed", indexPath!.row)
            }))
            
            alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action) in
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateTicketStatus(_ status : String, _ index : Int) {
        DispatchQueue.main.async {
            if let username = AppDelegate.user?.userName {
                self.ticketViewModel.postEditTicket(username: username, status: status, ticketId: self.activeTicketNotificationList[index].ticket_number) { (status) in
                    self.fetchData()
                }
            }
        }
    }
    
    func addGestureSwapeToSegment() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwiped(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwiped(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleSwiped(_ sender : UISwipeGestureRecognizer){
        segmentControl.selectedSegmentIndex = sender.direction == .right ? segmentControl.selectedSegmentIndex == 0 ? 0 : segmentControl.selectedSegmentIndex - 1 : segmentControl.selectedSegmentIndex == segmentControl.numberOfSegments - 1 ? segmentControl.numberOfSegments - 1 : segmentControl.selectedSegmentIndex + 1
        statusSegmentChangedPressed(segmentControl)
        
    }
    
    @IBAction func statusSegmentChangedPressed(_ sender : UISegmentedControl) {
        var status = "Open"
        switch sender.selectedSegmentIndex {
            case 0 :
            status = "Open"
            case 1 :
            status = "In Progress"
            case 2 :
            status = "Wait For Response"
            case 3 :
            status = "Closed"
            default :
                print("STH")
        }
        self.activeTicketNotificationList = self.ticketNotificationList.filter{$0.status==status}.sorted(by: {$1.modified_time < $0.modified_time})
        self.reloadData()
    }
    
    func reloadData(){
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
    
    private func addRightButton(){
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(named: "add-blue"), style: .plain, target: self, action: #selector(createTicket(_:)))
    }
    
    @objc func createTicket(_ sender : Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTicketViewControllerID") as! AddTicketViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func registerCell(){
        tableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketTableViewCellID")
        tableView.register(UINib(nibName: "TicketNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketNotificationTableViewCellID")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activeTicketNotificationList.count == 0 {
            tableView.setEmptyTableView(UIImage(named: "no_task"), "no ticket")
        } else {
            tableView.restore()
        }
        return activeTicketNotificationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketNotificationTableViewCellID") as! TicketNotificationTableViewCell
        cell.setData(activeTicketNotificationList[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.tableView.frame.size.height
        if (height < 600){
            return height / SIZE.NUM_ROW_PRO_SMALL
        }
        else if (height < 800) {
            return height / SIZE.NUM_ROW_PRO_MEDIUM
        }
        else {
            return height / SIZE.NUM_ROW_PRO_LARGE
        }
    }
    
    // MARK: TABLE VIEW DELEGATE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTicketViewControllerID") as! AddTicketViewController
        vc.ticket = activeTicketNotificationList[indexPath.row]
        vc.dept = dept
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TicketTableViewController : SwipeTableViewCellDelegate {
    
    func postEditStatus(status : String, ticketId : String) {
        DispatchQueue.main.async {
            guard let user = AppDelegate.user else { return }
            self.ticketViewModel.postEditTicket(username: user.userName, status: status, ticketId: ticketId) { (status) in
                self.fetchData()
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "edit".localized) { action, indexPath in
            let alert = UIAlertController(title: "edit status".localized, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Open", style: .default, handler: { (action) in
                self.postEditStatus(status: "Open", ticketId: self.ticketList[indexPath.row].ticket_number)
            }))
            alert.addAction(UIAlertAction(title: "In Progress", style: .default, handler: { (action) in
                self.postEditStatus(status: "In Progress", ticketId: self.ticketList[indexPath.row].ticket_number)
            }))
            alert.addAction(UIAlertAction(title: "Wait For Response", style: .default, handler: { (action) in
                self.postEditStatus(status: "Wait For Response", ticketId: self.ticketList[indexPath.row].ticket_number)
            }))
            alert.addAction(UIAlertAction(title: "Closed", style: .default, handler: { (action) in
                self.postEditStatus(status: "Closed", ticketId: self.ticketList[indexPath.row].ticket_number)
            }))
            alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action) in
                self.dismiss(animated: true) {
                    self.fetchData()
                }
            }))
            
            self.present(alert, animated: true) {
                
            }
        }
        deleteAction.image = UIImage(named: "edit")
        return [deleteAction]
    }
}

