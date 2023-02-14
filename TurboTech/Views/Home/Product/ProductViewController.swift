//
//  ProductViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    let lang = LanguageManager.shared.language
    
    lazy var productList : [Product] = []
    lazy var productViewModel = ProductViewModel()
    
    @IBOutlet weak var productTableView: UITableView!
    var position : Position?
    private var navItemTitle : String = "Unknown".localized
    private var typeId : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        switch typeId {
        case 0:
            productViewModel.productViewModelDelegate = self
            productViewModel.fetchAllProducts()
        case 2 :
            dataForHelpDesk()
        default:
            print("WRONG HZ PRO IT DEFULT")
        }
    }
    
    func setUpView(){
        navigationItem.title = navItemTitle
        setTableView()
    }
    
    func setNavigationTitle(title : String){
        self.navItemTitle = title
    }
    
    func setTypeId(id : Int){
        self.typeId = id
    }
}

extension ProductViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: "SubMenuCellID") as! SubMenuTableViewCell
        cell.setData(product: productList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.productTableView.frame.size.height
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
    
    func setTableView(){
        productTableView.dataSource = self
        productTableView.delegate = self
        productTableView.register(UINib(nibName: "SubMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SubMenuCellID")

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch typeId {
        case 0 :
            let cell = tableView.cellForRow(at: indexPath)
            let packageVC = storyboard?.instantiateViewController(withIdentifier: "PackageViewControllerID") as! PackageViewController
            packageVC.modalPresentationStyle = .fullScreen
            packageVC.setNavigationTitle(title: lang == "en" ? productList[indexPath.row].nameEn : productList[indexPath.row].nameKh)
            packageVC.setPackageId(id: cell!.tag)
            self.navigationController?.pushViewController(packageVC, animated: true)
        case 2:
            if indexPath.row == 0 {
                let packageVC = storyboard?.instantiateViewController(withIdentifier: "FeedBackViewControllerID") as! FeedBackViewController
                packageVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(packageVC, animated: true)
            }
            else if indexPath.row == 1 {
                let FAQsVC = storyboard?.instantiateViewController(withIdentifier: "FAQsTableViewControllerID") as! FAQsTableViewController
                FAQsVC.navigationItem.title = lang == "en" ? productList[indexPath.row].nameEn : productList[indexPath.row].nameKh
                FAQsVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(FAQsVC, animated: true)
                
            }
        default:
            print("Hey You Eng Love Me man? SI")
        }
        
    }
    
    
    
    
}

extension ProductViewController : ProductViewModelDelegate {
    func responseMessage(_ message: String) {
        
    }
    
    func responseSoftwareSolution(solutions: [SoftwareSolution]) {
        
    }
    
    func responsePackageDetail(packageDetails: [PackageDetail]) {
        
    }
    
    func responsePackage(packages: [Package]) {
        
    }
    
    func responseProduct(products: [Product]) {
        self.productList = products
        self.productList.append(Product(id: 3, nameEn: "Software Solution", nameKh: "ដំណោះស្រាយកម្មវិធី", imageUrl: "https://www.at-languagesolutions.com/en/wp-content/uploads/2016/06/http-1.jpg"))
        self.productTableView.reloadData()
    }
    
    func dataForHelpDesk(){
        self.productList.append(Product(id: 0, nameEn: "Complain", nameKh: "បញ្ចេញមតិ", imageUrl: "help-desk"))
        self.productList.append(Product(id: 1, nameEn: "FAQs", nameKh: "សំណួរ​ចម្លើយ", imageUrl: "faq"))
        self.productTableView.reloadData()
    }
    
}
