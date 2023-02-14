//
//  PopUpOverallAttendnaceTableViewController.swift
//  TurboTech
//
//  Created by Mr. iSQ on 12/2/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PopUpOverallAttendnaceTableViewController: UITableViewController {
    var pData = [[AttendancePresent]]()
    var aData = [[AttendanceAbsence]]()
    var isAbsent : Bool!
    
    private let pLabels = ["present morning".localized, "late morning".localized, "present afternoon".localized, "late afternoon".localized]
    private let aLabels = ["absent morning".localized, "permission morning".localized, "absent afternoon".localized, "permission afternoon".localized]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "PresentAttendanceTableViewCell", bundle: nil), forCellReuseIdentifier: "presentAttendanceCellItem")
        self.tableView.register(UINib(nibName: "AbsenceAttendanceTableViewCell", bundle: nil), forCellReuseIdentifier: "absenceAttendanceCellItem")
        self.tableView.register(UINib(nibName: "PermissionAttendanceTableViewCell", bundle: nil), forCellReuseIdentifier: "permissionAttendanceTableViewCell")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return isAbsent ? aData.count : pData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isAbsent ? aData[section].count : pData[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        isAbsent ? aLabels[section] : pLabels[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.isAbsent {
            case false :
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "presentAttendanceCellItem") as! PresentAttendanceTableViewCell
                cell.setData(pData[indexPath.section][indexPath.row], isPresent: indexPath.section % 2 == 0, isHiddenButton: true)
                return cell;
            case true :
                if(indexPath.section % 2 == 0) {
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "absenceAttendanceCellItem") as! AbsenceAttendanceTableViewCell
                    cell.setData(aData[indexPath.section][indexPath.row])
                    cell.editButton.isHidden = true
                    return cell
                } else {
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "permissionAttendanceTableViewCell") as! PermissionAttendanceTableViewCell
                    cell.setData(permission: aData[indexPath.section][indexPath.row])
                    return cell
                }
        case .none:
            fallthrough
        case .some(_):
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        112
    }
}
