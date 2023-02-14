//
//  Address.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

class Address {
    var gazcode : String
    var nameKh : String
    var nameEn : String
    
    init(json : JSON){
        self.gazcode = json["gazcode"].stringValue
        self.nameKh = json["Name_kh"].stringValue
        self.nameEn = json["Name_eng"].stringValue
    }
}

enum ADDRESS {
    case province
    case district
    case commune
    case village
}
