//
//  ERequestViewController.swift
//  TurboTech
//
//  Created by Mr. iSQ on 3/17/21.
//  Copyright © 2021 TurboTech. All rights reserved.
//

import UIKit

class ERequestViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var navigationTitle : UILabel!
    @IBOutlet weak var eRequestTableView : UITableView!
    private var eRequestViewModel = ERequestViewModel()
    
    var data = [ERequestForm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }
    
    private func setup(){
        self.navigationTitle.text = "eRequest Form".localized
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        fetchData()
        self.eRequestTableView.delegate = self
        self.eRequestTableView.dataSource = self
        eRequestTableView.register(UINib(nibName: "ERequestTableViewCell", bundle: nil), forCellReuseIdentifier: "ERequestTableViewCellID")
        self.eRequestTableView.refreshControl = UIRefreshControl()
        self.eRequestTableView.refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        self.eRequestTableView.refreshControl?.tintColor = COLOR.RED
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func fetchData(){
        DispatchQueue.main.async {
            self.eRequestViewModel.fetchERequestForm { (data) in
                self.data = data
                self.eRequestTableView.reloadData()
                self.eRequestTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
}

extension ERequestViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0 {
            tableView.setEmptyTableView(UIImage(named: "no_task"), "no data")
        } else {
            tableView.restore()
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERequestTableViewCellID") as! ERequestTableViewCell
        let d = data[indexPath.row]
        cell.setup(title: d.nameKh, isActive: d.isShow)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!data[indexPath.row].isShow) {
            self.showAndDismissAlert(self, title: "Under Maintenance", message: "", style: .alert, second: 1.0)
            return
        }
        switch data[indexPath.row].id {
        case 3 :
//            MARK: - Leave Applicaiton form
            print("LEAVE FORM")
            let vc = LeaveApplicationFormViewController(nibName: "LeaveApplicationFormViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        default :
            print("DEF")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
