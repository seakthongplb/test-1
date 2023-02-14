//
//  LeadDetailHistoryViewController.swift
//  TurboTech
//
//  Created by wo on 9/10/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class LeadDetailHistoryViewController: UIViewController {

    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var tableView : UITableView!
    
    var historyList = [LeadHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        registerCell()
        localized()
    }
    
    private func localized(){
        self.titleLabel.text = "lead history".localized
    }

}

extension LeadDetailHistoryViewController : UITableViewDelegate, UITableViewDataSource {
    
    func registerCell(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "LeadDetailHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadDetailHistoryTableViewCellID")

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadDetailHistoryTableViewCellID", for: indexPath) as! LeadDetailHistoryTableViewCell
        cell.setData(history: historyList[indexPath.row])
        return cell
    }
}

