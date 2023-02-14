//
//  PaymentAccount.swift
//  TurboTech
//
//  Created by sq on 7/17/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

class PaymentAccount {
    var id : Int!
    var accountName : String!
    var accountNumber : String!
    var imageUrl = "TT"
    
    init(id : Int, accountName : String, accountNumber : String, imageUrl : String){
        self.id = id
        self.accountName = accountName
        self.accountNumber = accountNumber
        self.imageUrl = imageUrl
    }
}
