//
//  RequestCRM.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

class RegisterPackageCRM {
    var fname : String?
    var lname : String?
    var email : String?
    var phone : String?
    var latlong : String? 
    var homeNStreetN : String?
    var packageId : String?
    var villageId : String?
    var userName : String?
    
    init(fname : String?, lname : String?, email : String?, phone : String?, latlong : String?, homeNStreetN : String?, packageId : String?, villageId : String?, userName : String? ) {
        self.fname = fname
        self.lname = lname
        self.email = email
        self.phone = phone
        self.latlong = latlong
        self.homeNStreetN = homeNStreetN
        self.packageId = packageId
        self.villageId = villageId
        self.userName = userName
    }
}

class CRMPackage : NSObject, PopUpSearchProtocol {
    var id : Int
    var name : String
    var isSelected = false
    
    init(json : JSON){
        self.id = json["id"].intValue
        self.name = json["Service Name"].stringValue
    }
    
    init(id : Int, name : String){
        self.id = id
        self.name = name
    }
    
}
