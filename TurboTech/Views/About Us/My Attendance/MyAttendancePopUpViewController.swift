//
//  MyAttendancePopUpViewController.swift
//  TurboTech
//
//  Created by wo on 9/10/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class MyAttendancePopUpViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var titleLabel : UILabel!
    
    var myAttendanceList = [MyAttendanceDetail]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup(){
        registerCell()
        fetchData()
        setData()
        localized()
    }
    
    private func fetchData(){}
    
    private func setData(){
    }
    
    private func localized(){
        self.titleLabel.text = "overall report".localized
    }
    
    private func reloadData(){
        
    }

}

extension MyAttendancePopUpViewController : UITableViewDelegate, UITableViewDataSource {
    func registerCell(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "MyAttendanceTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAttendanceTableViewCellID")

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.myAttendanceList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let w = tableView.frame.size.width
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: w, height: 24))
        headerView.backgroundColor = .white
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 4, width: 80, height: 18))
        dateLabel.text = "date".localized
        dateLabel.textColor = COLOR.COLOR_PRESENT
        dateLabel.textAlignment = .center
        headerView.addSubview(dateLabel)
        let checkInLabel = UILabel(frame: CGRect(x: 80, y: 4, width: (w-80)/2, height: 18))
        checkInLabel.text = "check in".localized
        checkInLabel.textColor = COLOR.COLOR_PRESENT
        checkInLabel.textAlignment = .center
        headerView.addSubview(checkInLabel)
        let checkOutLabel = UILabel(frame: CGRect(x: ((w-80)/2) + 80, y: 4, width: (w-80)/2, height: 18))
        checkOutLabel.text = "check out".localized
        checkOutLabel.textColor = COLOR.COLOR_PRESENT
        checkOutLabel.textAlignment = .center
        headerView.addSubview(checkOutLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAttendanceTableViewCellID", for: indexPath) as! MyAttendanceTableViewCell
        cell.setData(myAttendance: myAttendanceList[indexPath.row], isToday: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
}
