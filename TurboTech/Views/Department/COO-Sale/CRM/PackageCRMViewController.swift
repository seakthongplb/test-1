//
//  PackageCRMTableViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PackageCRMViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doneView: UIView!
    
    lazy var crmViewModel = CRMViewModel()
    lazy var ticketViewModel = TicketViewModel()
    var popUpSearchList = [PopUpSearchProtocol]()
    var filterPopUpSearchList = [PopUpSearchProtocol]()
    var onDoneBlock : ((_ id : Int, _ name : String) -> Void)?
    var selectedID : Int?
    var oldSelected : Int?
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor(white: 0.6, alpha: 0.6)
        
        tableView.register(UINib(nibName: "PackageCRMCellTableViewCell", bundle: nil), forCellReuseIdentifier: "PackageCRMCellTableViewCellID")
        tableView.delegate = self
        tableView.dataSource = self
        if let oldId = self.oldSelected {
            self.setSelected(id: oldId)
        }
        setupSearchBar()
        doneButton.setTitle("done".localized, for: .normal)
        containerView.layer.cornerRadius = SIZE.RADIUS_CARD
        doneView.layer.cornerRadius = SIZE.RADIUS_CARD
    }
    
    func setupSearchBar(){
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "search package ...".localized
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        tableView.tableHeaderView = (searchBar)
    }
    
    @IBAction func donePressed(_ sender : UIButton){
        self.dismiss(animated: true) {
            if let id = self.selectedID {
                self.onDoneBlock!(id, self.getPackageName(id: id))
            }
        }
    }
}

extension PackageCRMViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filterPopUpSearchList.isEmpty {
            return filterPopUpSearchList.count
        } else {
            return popUpSearchList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageCRMCellTableViewCellID", for: indexPath) as! PackageCRMCellTableViewCell
        if !filterPopUpSearchList.isEmpty {
            cell.setPackage(package: filterPopUpSearchList[indexPath.row])
            cell.isSelected(filterPopUpSearchList[indexPath.row].isSelected)
        } else {
            cell.setPackage(package: popUpSearchList[indexPath.row])
            cell.isSelected(popUpSearchList[indexPath.row].isSelected)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        if let oldId = oldSelected {
            removeSelected(id: oldId)
            oldSelected = nil
        }
        if let id = selectedID {
            removeSelected(id: id)
        }
        self.tableView.reloadData()
        if !filterPopUpSearchList.isEmpty {
            filterPopUpSearchList[indexPath.row].isSelected = true
            selectedID = filterPopUpSearchList[indexPath.row].id
        }
        else {
            popUpSearchList[indexPath.row].isSelected = true
            selectedID = popUpSearchList[indexPath.row].id
        }
    }
    
    func removeSelected(id : Int) {
        var c = 0
        for package in popUpSearchList {
            if package.id == id {
                popUpSearchList[c].isSelected = false
                return
            }
            c += 1
        }
    }
    
    func setSelected(id : Int){
        var c = 0
        for package in popUpSearchList {
            if package.id == id {
                popUpSearchList[c].isSelected = true
                return
            }
            c += 1
        }
    }
    
    func getPackageName(id : Int) -> String{
        var c = 0
        for package in popUpSearchList {
            if package.id == id {
                return popUpSearchList[c].name
            }
            c += 1
        }
        return "NOT FOUND"
    }
     
    
}

extension PackageCRMViewController : UISearchBarDelegate, UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filterPopUpSearchList = popUpSearchList.filter({$0.name.lowercased().contains(searchText.lowercased())})
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        filterPopUpSearchList.removeAll()
    }
}
