//
//  MyAttendanceView.swift
//  TurboTech
//
//  Created by wo on 9/4/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Kingfisher

class MyAttendanceView: UIView {
    
    var target : UIViewController?
    
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var myAttendanceTableView : UITableView!
    
    public var myAttendanceList : [MyAttendanceDetail] = [MyAttendanceDetail]()
    
    override init(frame: CGRect) {
    //  Using CustomView in Code
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
//      Using customView in IB
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        setup()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("MyAttendanceView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setup()
        fetchData()
    }
    
    private func setup(){
        self.registerCell()
        self.fetchData()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width/2
        self.profileImageView.layer.borderWidth = 0.5
        self.profileImageView.layer.borderColor = UIColor.gray.cgColor
        if let user = AppDelegate.user {
            let url = URL(string: user.imageUrl)
            self.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "user-circle"))
            self.usernameLabel.text = user.fullName
        }
    }
    
    private func fetchData(){
        self.myAttendanceTableView.reloadData()
    }

}

extension MyAttendanceView : UITableViewDelegate, UITableViewDataSource {
    func registerCell(){
        self.myAttendanceTableView.delegate = self
        self.myAttendanceTableView.dataSource = self
        myAttendanceTableView.register(UINib(nibName: "MyAttendanceTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAttendanceTableViewCellID")

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.myAttendanceList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let w = tableView.frame.size.width
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: w, height: 24))
        headerView.backgroundColor = .white
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 4, width: 80, height: 18))
        dateLabel.text = "date".localized
        dateLabel.textColor = COLOR.COLOR_PRESENT
        dateLabel.textAlignment = .center
        headerView.addSubview(dateLabel)
        let checkInLabel = UILabel(frame: CGRect(x: 80, y: 4, width: (w-80)/2, height: 18))
        checkInLabel.text = "check in".localized
        checkInLabel.textColor = COLOR.COLOR_PRESENT
        checkInLabel.textAlignment = .center
        headerView.addSubview(checkInLabel)
        let checkOutLabel = UILabel(frame: CGRect(x: ((w-80)/2) + 80, y: 4, width: (w-80)/2, height: 18))
        checkOutLabel.text = "check out".localized
        checkOutLabel.textColor = COLOR.COLOR_PRESENT
        checkOutLabel.textAlignment = .center
        headerView.addSubview(checkOutLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAttendanceTableViewCellID", for: indexPath) as! MyAttendanceTableViewCell
        cell.setData(myAttendance: myAttendanceList[indexPath.row], isToday: indexPath.row == myAttendanceList.count - 1 ? true : false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
}
