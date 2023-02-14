//
//  FinanceTableViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class FinanceTableViewController: UITableViewController {
    
    private var financeList = [Product]()

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
            self.financeList.append(Product(id: 0, nameEn: "Payment", nameKh: "ការបង់ប្រាក់", imageUrl: "payment"))
            self.financeList.append(Product(id: 1, nameEn: "Income", nameKh: "ចំណូល", imageUrl: "line.chart"))
            
            self.tableView.reloadData()
        }
    }

    private func setupCell() {
        tableView.register(UINib(nibName: "SubMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SubMenuCellID")
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.financeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubMenuCellID", for: indexPath) as! SubMenuTableViewCell
        cell.setData(product: self.financeList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            print("Payment")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentTableViewControllerID") as! PaymentTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
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
