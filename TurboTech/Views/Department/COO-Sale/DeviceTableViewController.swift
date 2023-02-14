//
//  DeviceTableViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class DeviceTableViewController: UITableViewController {

    let saleViewModel = SaleViewModel()
    var deviceList = [Device]()
    var filterDeviceList = [Device]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "launchScreen")!)
        tableView.register(UINib(nibName: "DeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "DeviceTableViewCellID")
        tableView.register(UINib(nibName: "DeviceHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "DeviceHeaderViewID")
        DispatchQueue.main.async {
            self.saleViewModel.fetchDevices { (devices) in
                self.deviceList = devices
                self.filterDeviceList = devices
                self.tableView.reloadData()
            }
        }
        setupSearchBar()
    }
    
    func setupSearchBar(){
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "search product ...".localized
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        tableView.tableHeaderView = (searchBar)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDeviceList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceTableViewCellID") as! DeviceTableViewCell
        cell.setData(device: filterDeviceList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DeviceHeaderViewID") as! DeviceHeaderView
        header.nameLabel.text = "Device"
        header.priceLabel.text = "Price"
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.frame.size.height
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
}

extension DeviceTableViewController : UISearchBarDelegate, UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterDeviceList = deviceList.filter({$0.name.lowercased().contains(searchText.lowercased()) || "\($0.price)".contains(searchText)})
        if searchText == "" {
            filterDeviceList = deviceList
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        filterDeviceList.removeAll()
    }
}
