//
//  PackageDetailViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class PackageDetailViewController: UIViewController {
    //@IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    
    var packageList = [PackageDetail]()
    lazy var packageDetailViewModel = ProductViewModel()
    private var packageId : Int = 0
    private var navItemTitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        packageList.append(PackageDetail())
        packageDetailViewModel.productViewModelDelegate = self
        packageDetailViewModel.fetchPackageDetail(packageId: packageId)
        setUpView()
    }
    
    override func viewWillLayoutSubviews() {
    }
    
    func setUpView(){
        navigationItem.title = navItemTitle
        detailTableView.estimatedRowHeight = 200
        detailTableView.rowHeight = UITableView.automaticDimension
        setTableView()
    }

    func setPackageId(id : Int){
        self.packageId = id
    }

    func setNavigationTitle(title : String){
        self.navItemTitle = title
    }

}

extension PackageDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(withIdentifier: "PackageDetailCellID") as! PackageDetailTableViewCell
        cell.applyButton.addTarget(self, action: #selector(applyNewService(_:)), for: .touchUpInside)
        cell.setData(package: packageList[indexPath.row])
        return cell
    }
    
    @objc func applyNewService(_ sender : Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterPackageViewControllerID") as! RegisterPackageViewController
        self.present(vc, animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PackageDetailHeaderViewID") as! PackageDetailHeaderView
//        header.titleLabel.text = "\(navItemTitle) Detail"
//        header.noteTextView.text = "Note: Helo\nWorld"
//        header.dotView.createDottedLine(width: 2, color: COLOR.WHITE.cgColor)
//        return header
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        128
//    }
    
    func setTableView(){
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(UINib(nibName: "PackageDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "PackageDetailCellID")
        let headerNib = UINib(nibName: "PackageDetailHeaderView", bundle: nil)
        detailTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "PackageDetailHeaderViewID")

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension PackageDetailViewController : ProductViewModelDelegate {
    func responseMessage(_ message: String) {
        NSLog("Hello Hello : \(message)")
    }
    
    func responseSoftwareSolution(solutions: [SoftwareSolution]) {
        
    }
    
    func responseProduct(products: [Product]) {
        
    }
    
    func responsePackage(packages: [Package]) {
        
    }
    
    func responsePackageDetail(packageDetails: [PackageDetail]) {
        self.packageList = packageDetails
        self.detailTableView.reloadData()
    }
    
    
}

