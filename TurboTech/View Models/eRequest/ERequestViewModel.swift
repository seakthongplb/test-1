//
//  ERequestViewModel.swift
//  TurboTech
//
//  Created by Mr. iSQ on 3/18/21.
//  Copyright © 2021 TurboTech. All rights reserved.
//

import Foundation

class ERequestViewModel {
    private var eRequestService = ERequestService()
    
    func fetchERequestForm(completion : @escaping(_ data : [ERequestForm])->()){
        eRequestService.fetchERequestForm { (data) in
            completion(data)
        }
    }
    
    func fetchRequest(_ id : Int, isOwnRequest : Bool, completion : @escaping(_ data : [ERequest])->()){
        eRequestService.fetchRequest(id, isOwnRequest: isOwnRequest) { (data) in
            completion(data)
        }
    }
    
    func fetchAllRequests(_ id : Int, completion : @escaping(_ data : [ERequest])->()){
        eRequestService.fetchAllRequests(id) { (data) in
            completion(data)
        }
    }
    
    func fetchKindOfLeave(completion : @escaping(_ data : [KindOfLeave])->()){
        eRequestService.fetchKindOfLeave { (data) in
            completion(data)
        }
    }
    
    func postLeaveApplicationForm(formData : (formId : Int, kindOfLeaveId : Int, dateFrom : String, dateTo : String, dateResume : String, numberDateleave : Double, reason : String?, transferTo : Int?, userId : Int),completion : @escaping(_ status : Bool)->()){
        eRequestService.postLeaveApplicationForm(data : formData) { (data) in
            completion(data)
        }
    }
    
    func postERequestDetail(data : (eRequestId : Int, comment : String?, status : String, userId : Int), completion : @escaping((_ status : Bool)->())){
        eRequestService.postERequestDetail(data: data) { (status) in
            completion(status)
        }
    }
    
}
