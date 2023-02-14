//
//  DepartmentViewController.swift
//  TurboTech
//
//  Created by Sov Sothea on 5/27/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

/*
import UIKit

class DepartmentViewController: UIViewController {
    
    // IBOutlet of DepartmentViewController
    @IBOutlet weak var departmentTableViewOutlet: UITableView!
    
    // Declare Variable
//    let data = ["Information", "Department", "Language", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call Function
        registerTableViewCell()
        
    }
    
    func registerTableViewCell() {
        // Close Table Footer
        departmentTableViewOutlet.tableFooterView = UIView()
        departmentTableViewOutlet.register(UINib(nibName: "DepartmentTableViewCell", bundle: nil), forCellReuseIdentifier: "departmentCellItem")
        departmentTableViewOutlet.delegate = self
        departmentTableViewOutlet.dataSource = self
    }
}

extension DepartmentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departmentCellItem") as! DepartmentTableViewCell
//        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = indexPath.row
        switch selection {
        case 0:
            let attendanceVC = storyboard?.instantiateViewController(withIdentifier: "AttendanceViewControllerID") as! AttendanceViewController
//            self.present(attendance, animated: false, completion: nil)
            self.showDetailViewController(attendanceVC, sender: nil)
//            self.navigationController?.pushViewController(attendance, animated: true)
        case 1:
            print(selection)
            print("Hello number 1")
        case 2:
            print(selection)
            print("Hello number 2")
        default:
            print(selection)
            print("Hello number 3")
        }
    }
}
*/
