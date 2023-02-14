//
//  FAQsTableViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class FAQsTableViewController: UITableViewController {

    var FAQsList = [SupportQuestion]()
    let lang = LanguageManager.shared.language
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setData()
    }
    
    func setupView(){
        let nib = UINib(nibName: "FAQsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FAQsTableViewCellID")
        
        let headerNib = UINib(nibName: "FAQsTableViewHeader", bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "FAQsTableViewHeaderID")
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "launchScreen"))
    }
    
    func setData(){
        let helpDeskViewModel = HelpDeskViewModel()
        DispatchQueue.main.async {
            helpDeskViewModel.fetchAllFAQs { (list) in
                self.FAQsList = list
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return FAQsList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FAQsList[section].isCollapse == true ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQsTableViewCellID", for: indexPath) as! FAQsTableViewCell
        cell.backgroundColor = .clear
        cell.setData(answer: lang == "en" ? FAQsList[indexPath.section].answerEn : FAQsList[indexPath.section].answerKh)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FAQsTableViewHeaderID") as! FAQsTableViewHeader
        header.setData(question: lang == "en" ? FAQsList[section].questionEn : FAQsList[section].questionKh )
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapSection(_:)))
        header.isUserInteractionEnabled = true
        header.addGestureRecognizer(tap)
        header.tag = section
        return header
    }
    
    @objc
    func tapSection(_ sender : UITapGestureRecognizer){
        guard let tag = sender.view?.tag else {
            return
        }

        self.FAQsList[tag].isCollapse = self.FAQsList[tag].isCollapse == true ? false : true
        self.tableView.reloadSections([tag], with: .fade)
    }

}
