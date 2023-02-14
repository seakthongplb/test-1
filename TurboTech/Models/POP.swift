//
//  POP.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

class POP {
    let code : Int
    let nameEn : String
    let nameKh : String
    let latitude : Double
    let longitude : Double
    
    init(json : JSON){
        self.code = json["code"].intValue
        self.nameEn = json["Name"].stringValue
        self.nameKh = json["Name kh"].stringValue
//        print(json["lat"].stringValue, json["lng"].stringValue)
        self.latitude = json["lat"].doubleValue
        self.longitude = json["lng"].doubleValue
    }
}

class PopDetail {
    var poplabel : String
    var productLabel : String
    var qty : Int
    var unit : String
    
    init(json : JSON){
        poplabel = json["name"].stringValue
        productLabel = json["product"].stringValue
        qty = json["qty"].intValue
        unit = json["unit"].stringValue
    }
}

class PopInnerDetail {
    var popContact : PopContact
    var popProduct = [PopProduct]()
    var popCustomer = [PopCustomer]()
    
    init(json : JSON){
        self.popContact = PopContact(json: json["contact"][0])
        for pro in json["result"].arrayValue {
            self.popProduct.append(PopProduct(json: pro))
        }
        for cus in json["customer"].arrayValue {
            self.popCustomer.append(PopCustomer(json: cus))
        }
    }
}

protocol PopInner {
    
}

class PopContact {
    var contactName : String
    var phone : String
    var core : String
    var customer : String
    
    init(json : JSON){
        self.contactName = json["contactName"].stringValue
        self.phone = json["phone"].stringValue
        self.core = json["core"].stringValue
        self.customer = json["customer"].stringValue
    }
}

class PopProduct : PopInner{
    var popId : String
    var name : String
    var latlong : String
    var product : String
    var qty : String
    var unit : String
    var pic : String
    
    init(json : JSON){
        self.popId = json["POPid"].stringValue
        self.name = json["name"].stringValue
        self.latlong = json["latlong"].stringValue
        self.product = json["product"].stringValue
        self.qty = json["qty"].stringValue
        self.unit = json["unit"].stringValue
        self.pic = json["pic"].stringValue
    }
}

class PopCustomer : PopInner{
    var cif : String
    var accountName : String
    var core : String
    
    init(json: JSON){
        self.cif = json["cif"].stringValue
        self.accountName = json["accountname"].stringValue
        self.core = json["core"].stringValue
    }
}
