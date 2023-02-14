//
//  User.swift
//  TurboTech
//
//  Created by Sov Sothea on 5/22/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase

class User {
    
    var id : String
    var fullName : String
    var userName : String
    var position : Position
    var department : DepartmentType
    var positionCRM : Position
    var departmentCRM : DepartmentType
    var imageUrl : String
    var phone : String
    var mainappId : Int?
    
    init(json: JSON){
        print(json)
        self.id = json["ID Card"].stringValue
        self.fullName = json["Full Name"].stringValue
        self.userName = json["User Name"].stringValue
        if let dept = DepartmentType(rawValue: json["Department"].stringValue) {
            self.department = dept
            self.departmentCRM = dept
        } else {
            self.department = .NONE
            self.departmentCRM = .NONE
        }

        if let pos = Position(rawValue: json["Position"].stringValue) {
            self.position = pos
            self.positionCRM = pos
        } else {
            self.position = .none
            self.positionCRM = .none    
        }
        
        self.imageUrl = APIManager.IMAGE_PRO + json["Image"].stringValue
        self.phone = json["Phone"].stringValue
    }
    
    func update(json: JSON){
        if let dept = DepartmentType(rawValue: json["Department_crm"].stringValue) {
            self.departmentCRM = dept
        } else {
            self.departmentCRM = .NONE
        }

        if let pos = Position(rawValue: json["Position_crm"].stringValue) {
            self.positionCRM = pos
        } else {
            self.positionCRM = .none
        }
        print(self.departmentCRM, self.positionCRM)
    }
    
    func updateMainAppId(id : Int?){
        self.mainappId = id
    }
    
    static func resetUser(){
        let userDefault = UserDefaults.standard
        userDefault.set(false, forKey: "isLogin")
        AppDelegate.user = nil
        userDefault.set(nil, forKey: "curUsername")
        userDefault.set(nil, forKey: "curPassword")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out : %@ : ", signOutError)
        }
        userDefault.synchronize()
        
    }
    
    static func setupUser(username : String, password : String, user : User){
        let userDefault = UserDefaults.standard
        userDefault.set(true, forKey: "isLogin")
        AppDelegate.user = user
        userDefault.set(username, forKey: "curUsername")
        userDefault.set(password, forKey: "curPassword")
        userDefault.synchronize()
    }
    
    static func setNewPassword(password : String){
        let userDefault = UserDefaults.standard
        userDefault.set(true, forKey: "isLogin")
        userDefault.set(password, forKey: "curPassword")
        userDefault.synchronize()
    }
}
