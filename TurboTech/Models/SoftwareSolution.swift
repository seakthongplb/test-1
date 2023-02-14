//
//  SoftwareSolution.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SoftwareSolution {
    var id : Int
    var nameEn : String
    var nameKh : String
    var detailEn : String
    var detailKh : String
    var imageUrl : String
    var imageWebUrl : String
    
    init(json : JSON){
        self.id = json["id"].intValue
        self.nameEn = json["name en"].stringValue
        self.nameKh = json["name kh"].stringValue
        self.detailEn = json["detail en"].stringValue
        self.detailKh = json["detail kh"].stringValue
        self.imageUrl = APIManager.IMAGE_URL + json["image"].stringValue
        self.imageWebUrl = APIManager.IMAGE_WEB_URL + json["image_web"].stringValue
    }
    init(){
        self.id = 11
        self.detailEn = "hhh"
        self.detailKh = "ហហហ"
        self.nameEn = "ABC"
        self.nameKh = ""
        self.imageUrl = ""
        self.imageWebUrl = ""
    }
}
