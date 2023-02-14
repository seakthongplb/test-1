//
//  ERequest.swift
//  TurboTech
//
//  Created by Mr. iSQ on 3/17/21.
//  Copyright © 2021 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ERequestForm {
    var id : Int
    var nameEn : String
    var nameKh : String
    var isShow : Bool
    
    init(json : JSON){
        id = json["id"].intValue
        nameEn = json["name_en"].string ?? "-"
        nameKh = json["name_kh"].string ?? "-"
        isShow = json["is_show_on_phone"].boolValue
    }
}

struct KindOfLeave {
    var id : Int
    var nameEn : String
    var nameKh : String
    
    init(json : JSON){
        id = json["id"].intValue
        nameEn = json["name_en"].string ?? "-"
        nameKh  = json["name_kh"].string ?? "-"
    }
}

// MARK: - ERequest
struct ERequest {
    var id, eRequestFormID, formTableRowID: Int
    var requestName, formName, createDate, requestBy, eRequestStatus, comment, actionBy: String
    var eRequestDetail: [ERequestDetail]
    var formDetail: FormDetail?
    
    init(json : JSON){
        id = json["id"].intValue
        requestName = json["name"].string ?? "-"
        formName = json["form_name"].string ?? "-"
        createDate = json["create_date"].stringValue.toDate(fromDateFormat: .yyyymdd_hhmmssZ, toFormat: .mmmddyyy_hhmmss)
        eRequestFormID = json["e_request_form_id"].intValue
        requestBy = json["request_by"].string ?? "-"
        eRequestStatus = json["e_request_status"].string ?? "-"
        comment = json["comment"].string ?? "-"
        actionBy = json["action_by"].string ?? "-"
        formTableRowID = json["form_table_row_id"].intValue
        
        switch(eRequestFormID){
            case 3 :
                formDetail = LeaveApplicationForm(json: json["form_detail"])
            default :
                print("DEF")
        }
        
        var list = [ERequestDetail]()
        for j in json["e_request_detail"].arrayValue {
            list.append(ERequestDetail(json: j))
        }
        eRequestDetail = list
    }
}

// MARK: - ERequestDetail
struct ERequestDetail {
    var id, eRequestID: Int
    var date, eRequestStatus, comment, actionByName: String
    
    init(json : JSON){
        id = json["id"].intValue
        eRequestID = json["e_request_id"].intValue
        date = json["timezone"].stringValue.toDate(fromDateFormat: .yyyymdd_hhmmssZ, toFormat: .mmmddyyy_hhmmss)
        eRequestStatus = json["e_request_status"].string ?? "-"
        comment = json["comment"].string ?? "-"
        actionByName = json["action_by_name"].string ?? "-"
    }
}

class FormDetail {}

// MARK: - FormDetail
class LeaveApplicationForm : FormDetail {
    var id, requestBy, kindOfLeaveID, transferJobTo: Int
    var createDate, dateFrom, dateTo, dateResume : Date?
    var numberDateLeave, reason, name, nameKh, annualCount: String
    
    init(json : JSON){
        id = json["id"].intValue
        requestBy = json["request_by"].intValue
        kindOfLeaveID = json["kind_of_leave_id"].intValue
        transferJobTo = json["transfer_job_to"].intValue
        createDate = json["create_date"].stringValue.toDate()
        dateFrom = json["date_from"].stringValue.toDate()
        dateTo = json["date_to"].stringValue.toDate()
        dateResume = json["date_resume"].stringValue.toDate()
        numberDateLeave = json["number_date_leave"].string ?? "-"
        reason = json["reason"].string ?? "-"
        name = json["name"].string ?? "-"
        nameKh = json["name_kh"].string ?? "-"
        annualCount = json["annual_count"].string ?? "-"
    }
}
