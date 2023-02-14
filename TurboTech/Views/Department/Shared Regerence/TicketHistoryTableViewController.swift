//
//  TicketHistoryTableViewController.swift
//  TurboTech
//
//  Created by wo on 9/4/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class TicketHistoryTableViewController: UITableViewController {

    var ticketId : String!
    private var histories = [TicketHistory]()
    private var ticketViewModel : TicketViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        ticketViewModel = TicketViewModel()
        registerCell()
        fetchData()
    }
    
    private func fetchData(){
        DispatchQueue.main.async {
            self.ticketViewModel.getTicketHistory(ticketId: self.ticketId) { (list) in
                self.histories = list
                self.tableView.reloadData()
            }
        }
    }
    
    private func registerCell(){
        tableView.register(UINib(nibName: "TicketHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketHistoryTableViewCellID")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketHistoryTableViewCellID", for: indexPath) as! TicketHistoryTableViewCell
        cell.setData(history: histories[indexPath.row])
        return cell
    }
}
