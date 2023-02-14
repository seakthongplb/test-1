//
//  PackageDetail.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

class PackageDetail {
    var id : Int
    var nameEn : String
    var nameKh : String
    var price : String
    var speed : String
    var detailEn : String
    var detailKh : String
    var packageId : Int
    var serviceId : Int
    
    init(json : JSON){
        self.id = json["id"].intValue
        self.nameEn = json["name en"].stringValue
        self.nameKh = json["name kh"].stringValue
        self.price = json["price"].stringValue
        self.speed = json["speed"].stringValue
        self.detailEn = json["product_fea_en"].stringValue
        self.detailKh = json["speproduct_fea_kh"].stringValue
        self.packageId = json["package_id"].intValue
        self.serviceId = json["service_id"].intValue
    }
    init(){
        self.id = 11
        self.detailEn = "hhh"
        self.detailKh = "ហហហ"
        self.nameEn = "ABC"
        self.nameKh = ""
        self.packageId = 10
        self.price = "100"
        self.speed = "10"
        self.serviceId = 10
    }
    
    func setDetailEn(str : String){
        self.detailEn = str
    }
    
    func setDetailKh(str : String){
        self.detailKh = str
    }
}
