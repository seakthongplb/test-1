//
//  HelpDeskService.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HelpDeskService{
    
    let headers : HTTPHeaders = APIManager.HEADER
    
    func postComplainMessage(complain : UserComplain, handler : @escaping(_ message : String)->()){
        
        let params = [
            "protypename" : complain.type,
            "question" : complain.question
        ]
        
        var message = ""
        
        AF.request(APIManager.HELP_DESK.POST, method: .post, parameters: params, encoding: URLEncoding.default).response { (response) in
            guard let data = response.data else { return }
            if let json = try? JSON(data: data){
                message = json["message"].string ?? "NO POST"
                if message == "NO ID" {
                    self.defaultPostComplain(complain: complain) { (msg) in
                        message = msg
                    }
                }
            }
            handler(message)
        }
    }
    
    private func defaultPostComplain(complain : UserComplain, handler : (_ message : String)->()){
        
        let params = ["protypename" : "Internet", "question" : complain.question]
        var message = ""
        AF.request(APIManager.HELP_DESK.POST, method: .post, parameters: params, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let json = try? JSON(data: data){
                message = json["message"].stringValue
            }
        }
        handler(message)
    }
    
    func fetchAllFAQs(handler : @escaping(_ FAQsList : [SupportQuestion])->()){
        var FAQsList = [SupportQuestion]()
        AF.request("\(APIManager.HELP_DESK.GET)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let sq = SupportQuestion(json: json)
                    FAQsList.append(sq)
                }
            }
            handler(FAQsList)
        }
    }
    
    func fetchProblemType(completionHandler : @escaping(_ problemList : [ProblemType])->()){
        var problemList = [ProblemType]()
        AF.request("\(APIManager.HELP_DESK.GET_PROBLEM)", method: .get, headers: headers).response{(response) in
            guard let data = response.data else {return}
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let type = ProblemType(json: json)
                    problemList.append(type)
                }
            }
            completionHandler(problemList)
        }
    }
    
}
