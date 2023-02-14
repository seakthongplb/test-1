//
//  Device.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

class Device {
    var name : String
    var price : Double
    var imageUrl : String
    
    init(json : JSON){
        self.name = json["name"].stringValue
        self.imageUrl = APIManager.DEVICE_IMAGE + json["image"].stringValue
        self.price = round(json["price"].doubleValue * 10000) / 10000
    }
}
