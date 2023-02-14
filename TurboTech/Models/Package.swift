//
//  Package.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

class Package {
    var productId : Int
    var id : Int
    var nameEn : String
    var nameKh : String
    var imageUrl : String
    
    init(id : Int, nameEn : String, nameKh : String, imageUrl : String, productId : Int){
        self.id = id
        self.nameEn = nameEn
        self.nameKh = nameKh
        self.imageUrl = imageUrl
        self.productId = productId
    }
    
    init(json : JSON) {
        self.id = json["id"].intValue
        self.nameEn = json["name en"].stringValue
        self.nameKh = json["name kh"].stringValue
        self.imageUrl = APIManager.IMAGE_URL + json["image"].stringValue
        self.productId = json["service_ID"].intValue
    }
}
