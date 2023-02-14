//
//  ERequestService.swift
//  TurboTech
//
//  Created by Mr. iSQ on 3/17/21.
//  Copyright © 2021 TurboTech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ERequestService {
    let headers : HTTPHeaders = APIManager.HEADER
    
    func fetchERequestForm(completion : @escaping(_ data : [ERequestForm])->()){
        AF.request(APIManager.E_Request.GET_E_REQUEST_FORM, method: .get).response{ response in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                var list = [ERequestForm]()
                if(jsons["success"].boolValue){
                    for json in jsons["data"].arrayValue {
                        let l = ERequestForm(json: json)
                        list.append(l)
                    }
                    completion(list)
                }
            }
        }
    }
    
    func fetchRequest(_ id : Int, isOwnRequest : Bool, completion : @escaping(_ data : [ERequest])->()){
        
        let url = isOwnRequest ? APIManager.E_Request.GET_OWN_REQUEST : APIManager.E_Request.GET_APPROVE_REQUEST
        
        AF.request(url + "?user_id=\(id)", method: .get).response {reseponse in
            guard let data = reseponse.data else { return }
            if let jsons = try? JSON(data: data) {
                if jsons["success"].boolValue {
                    var list = [ERequest]()
                    for json in jsons["data"].arrayValue {
                        let l = ERequest(json: json)
                        list.append(l)
                    }
                    completion(list)
                }
            }
        }
    }
    
    func fetchAllRequests(_ id : Int, completion : @escaping(_ data : [ERequest])->()){
        
        let url = APIManager.E_Request.GET_ALL_REQUESTS
        
        AF.request(url + "?user_id=\(id)", method: .get).response {reseponse in
            guard let data = reseponse.data else { return }
            if let jsons = try? JSON(data: data) {
                if jsons["success"].boolValue {
                    var list = [ERequest]()
                    for json in jsons["data"].arrayValue {
                        let l = ERequest(json: json)
                        list.append(l)
                    }
                    completion(list)
                }
            }
        }
    }
    
    func fetchKindOfLeave(completion : @escaping(_ data : [KindOfLeave])->()){
        AF.request(APIManager.E_Request.GET_KIND_OF_LEAVE, method: .get).response{ response in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                var list = [KindOfLeave]()
                if(jsons["success"].boolValue){
                    for json in jsons["data"].arrayValue {
                        let l = KindOfLeave(json: json)
                        list.append(l)
                    }
                    completion(list)
                }
            }
        }
    }
    
    func fetchRequest(_ id : String, completion : @escaping(_ id : Int)->()){
        AF.request(APIManager.E_Request.GET_USER + "?card_id=\(id)", method: .get).response {reseponse in
            guard let data = reseponse.data else { return }
            if let jsons = try? JSON(data: data) {
                if jsons["success"].boolValue {
                    completion(jsons["data"]["id"].intValue)
                }
            }
        }
    }
    
    func postLeaveApplicationForm(data : (formId : Int, kindOfLeaveId : Int, dateFrom : String, dateTo : String, dateResume : String, numberDateleave : Double, reason : String?, transferTo : Int?, userId : Int),completion : @escaping(_ status : Bool)->()){
        let parameters = [
            "form_id" : data.formId,
            "kind_of_id" : data.kindOfLeaveId,
            "date_form" : data.dateFrom,
            "date_to" : data.dateTo,
            "date_resume" : data.dateResume,
            "number_date_leave" : data.numberDateleave,
            "reason" : data.reason ?? "",
            "transfer_to" : data.transferTo ?? "" as Any,
            "user_id" : data.userId
        ] as [String : Any]
        
        for para in parameters {
            print(para)
        }
        
        AF.request(APIManager.E_Request.POST_LEAVE_APPLICATION, method: .post, parameters: parameters).response { response in
            guard let data = response.data else {
                completion(false)
                return
            }
            if let json = try? JSON(data: data) {
                print(json)
                completion(json["success"].boolValue)
            } else {
                completion(false)
            }
            
        }
    }
    
    func postERequestDetail(data : (eRequestId : Int, comment : String?, status : String, userId : Int), completion : @escaping((_ status : Bool)->())){
        let parameters = [
            "e_request_id" : data.eRequestId,
            "comment" : data.comment ?? "",
            "status" : data.status,
            "user_id" : data.userId
        ] as [String : Any]
        
        AF.request(APIManager.E_Request.POST_E_REQUEST_DETAIL, method: .post, parameters: parameters).response{ response in
            guard let data = response.data else {
                completion(false)
                return
            }
            if let json = try? JSON(data: data) {
                completion(json["success"].boolValue)
            } else {
                completion(false)
            }
        }
    }
    
}

