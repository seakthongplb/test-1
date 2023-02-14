//
//  SupportQuestion.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SupportQuestion {
    var id : Int
    var questionEn : String
    var questionKh : String
    var answerEn : String
    var answerKh : String
    var date : String
    var isCollapse = true // បិទ
    
    init(json : JSON){
        self.id = json["id"].intValue
        self.questionEn = json["q_en"].stringValue
        self.questionKh = json["q_kh"].stringValue
        self.answerEn = json["a_en"].stringValue
        self.answerKh = json["a_kh"].stringValue
        self.date = json["date"].stringValue
    }
    
    func setQuestion(en : String, kh : String){
        self.questionEn = en
        self.questionKh = kh
    }
    
    func setAnswer(en : String, kh : String){
        self.answerEn = en
        self.answerKh = kh
    }
}
