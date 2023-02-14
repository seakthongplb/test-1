//
//  HelpDesk.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserComplain {
    var type : String
    var question : String
    
    init(type : String, question : String){
        self.type = type
        self.question = question
    }
    
    func setType(type : String){
        self.type = type
    }
    
    func setQuestion(question : String) {
        self.question = question
    }
}

class ProblemType {
    var id : Int
    var nameEn : String
    var nameKh : String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.nameEn = json["name_en"].stringValue
        self.nameKh = json["name_kh"].stringValue
    }
    
    func getId() -> Int{
        return self.id
    }
}
