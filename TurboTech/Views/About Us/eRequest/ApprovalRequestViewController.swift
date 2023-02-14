//
//  ApprovalRequestViewController.swift
//  TurboTech
//
//  Created by Mr. iSQ on 3/19/21.
//  Copyright © 2021 TurboTech. All rights reserved.
//

import UIKit

class ApprovalRequestViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var navigationTitle : UILabel!
    @IBOutlet weak var eRequestTableView : UITableView!
    private var eRequestViewModel = ERequestViewModel()
    
    var data = [ERequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        self.navigationTitle.text = "Approval Request".localized
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.eRequestTableView.delegate = self
        self.eRequestTableView.dataSource = self
        eRequestTableView.register(UINib(nibName: "ApprovalRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "ApprovalRequestTableViewCellID")
        self.eRequestTableView.refreshControl = UIRefreshControl()
        self.eRequestTableView.refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        self.eRequestTableView.refreshControl?.tintColor = COLOR.RED
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func fetchData(){
        DispatchQueue.main.async {
            guard let id = AppDelegate.user?.mainappId else { return }
            self.eRequestViewModel.fetchRequest(id, isOwnRequest: false, completion: { (data) in
                self.data = data
                self.eRequestTableView.reloadData()
                self.eRequestTableView.refreshControl?.endRefreshing()
            })
        }
    }
    
}

extension ApprovalRequestViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0 {
            tableView.setEmptyTableView(UIImage(named: "no_task"), "no data")
        } else {
            tableView.restore()
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalRequestTableViewCellID") as! ApprovalRequestTableViewCell
        let d = data[indexPath.row]
        cell.setData(eRequest: d)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch data[indexPath.row].eRequestFormID {
        case 3 :
//            MARK: - Leave Applicaiton form
            print("LEAVE FORM")
            let vc = LeaveApplicationFormViewController(nibName: "LeaveApplicationFormViewController", bundle: nil)
            vc.readView(eRequest: self.data[indexPath.row], isApprovalForm: true)
            self.navigationController?.pushViewController(vc, animated: true)
        default :
            self.showAndDismissAlert(self, title: "Under Maintenance", message: "", style: .alert, second: 1.0)
        }
    }
}
