//
//  AttendanceReportDetailTableViewController.swift
//  TurboTech
//
//  Created by wo on 9/12/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class AttendanceReportDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel : UILabel!
    
    var data = [AttendanceReportDetail]()
    var isEarly  = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        self.titleLabel.text = isEarly ? "early report".localized : "late report".localized
        tableView.register(UINib(nibName: "MonthlyReportTableViewCell", bundle: nil), forCellReuseIdentifier: "MonthlyReportTableViewCellID")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthlyReportTableViewCellID", for: indexPath) as! MonthlyReportTableViewCell
        cell.setData(data[indexPath.row], isEarly)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
    
}
