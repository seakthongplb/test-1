//
//  FinanceTableViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PaymentTableViewController: UITableViewController {
    
    private var accountList = [PaymentAccount]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "launchScreen")!)
        setup()
        setupCell()
        fetchData()
    }
    
    private func setup() {
    }
    
    private func fetchData() {
        DispatchQueue.main.async {
            self.accountList.append(PaymentAccount(id: 0, accountName: "TURBOTECH CO LTD", accountNumber: "000 488 896", imageUrl: "aba-bank-logo"))
            self.accountList.append(PaymentAccount(id: 1, accountName: "TURBOTECH CO LTD", accountNumber: "1010 1280 3888 8888", imageUrl: "cimb-bank-logo"))
            
            self.tableView.reloadData()
        }
    }

    private func setupCell() {
        tableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCellID")
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCellID", for: indexPath) as! PaymentTableViewCell
        cell.setData(account: self.accountList[indexPath.row])
//        cell.setData(product: self.financeList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            print("Payment")
        case 1 :
            print("Income")
        default:
            print("Default")
        }
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
