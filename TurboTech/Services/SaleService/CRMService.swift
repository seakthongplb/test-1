//
//  File.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class CRMService {
    
    let headers : HTTPHeaders = APIManager.HEADER
    
    // MARK: - Fetch Data
    func fetchAllLeadByUsernameYearMonth(username : String, year : String, month : String, completion : @escaping(_ convert : Int, _ unconvert : Int, _ position : String?, _ list : [LeadAll])-> Void){
        var dataList = [LeadAll]()
        var conNum : Int = 0
        var unconNum : Int = 0
        var role : String?
        print(APIManager.CRM.GET_LEAD_ALL + "?username=\(username)&year=\(year)&month=\(month)")
        AF.request(APIManager.CRM.GET_LEAD_ALL + "?username=\(username)&year=\(year)&month=\(month)", method: .get, headers: headers).response { (reponse) in
            guard let data = reponse.data else {return}
            if let jsons = try? JSON(data: data) {
                if jsons["Message5"].stringValue != "" {
                    return
                }
                if jsons["message"].string == nil {
                    role = jsons["role"][0]["role"].stringValue
                    conNum = jsons["result_convert"].arrayValue[0]["converted"].intValue
                    unconNum = jsons["result_convert"].arrayValue[0]["not_convert"].intValue
                    for json in jsons["result"].arrayValue {
                        let data = LeadAll(json: json)
                        dataList.append(data)
                    }
                }
            }
            completion(conNum, unconNum, role, dataList)
        }
    }
    
    func fetchDropDownData(crmPickerEnum : CRMPickerEnum, completion : @escaping(_ list : [CRMPickerData])->()) {
        var url : String = ""
        switch crmPickerEnum {
        case .vatType :
            url = APIManager.CRM.GET_VAT_TYPE
        case .customerType:
            url = APIManager.CRM.GET_CUSTOMER_TYPE
        case .customerRate:
            url = APIManager.CRM.GET_CUSTOMER_RATE
        case .industry:
            url = APIManager.CRM.GET_INDUSTRY
        case .assignedTo:
            url = APIManager.CRM.GET_ASSIGNED_TO
        case .branch:
            url = APIManager.CRM.GET_BRANCH
        case .leadStatus :
            url = APIManager.CRM.GET_STATUS
        }
        
        var dataList = [CRMPickerData]()
        AF.request(url, method: .get, headers: headers).response { (reponse) in
            guard let data = reponse.data else {return}
            if let jsons = try? JSON(data: data) {
                for json in jsons["result"].arrayValue {
                    let data = CRMPickerData(json: json)
                    dataList.append(data)
                }
            }
            completion(dataList)
        }
        
    }
    
    func fetchRegisterPackage(completion : @escaping(_ packageList : [CRMPackage])->()){
        var packageList = [CRMPackage]()
        AF.request("\(APIManager.CRM.GET_PACKAGE)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let package = CRMPackage(json: json)
                    packageList.append(package)
                }
            }
            completion(packageList)
        }
    }
    
    func fetchLeadByLeadId(id : String, completion : @escaping(_ message : String?, _ lead : Lead?)->Void){
        AF.request(APIManager.CRM.GET_LEAD_BY_ID + "?leadid=" + id, method: .get, headers: headers).response { (reponse) in
            guard let data = reponse.data else { return }
            if let jsons = try? JSON(data: data) {
                if let message = jsons["message"].string {
                    completion(message, nil)
                } else {
                    completion(nil, Lead(json: jsons))
                }
            }
        }
    }
    
    
    // MARK: POST_UPDATE
    func postCreateNewLead(username : String, leadId : String?, leadInfo : CRMLeadInformation, contactInfo : CRMContactInformation, addressInfo : CRMAddressInformation, completion : @escaping(_ message : String, _ lead : LeadDetail?)->()) {
        var parameters = [String : Optional<String>]()
        if leadId == nil {
            parameters = [
                // MARK: - Lead Information
                "username" : username,
                "company_en" : leadInfo.compnayName,
                "company_kh" : leadInfo.customerName,
                "primary_phone" : leadInfo.primaryPhone,
                "vat_type" : leadInfo.vatType,
                "custo_type" : leadInfo.customerType,
                "custo_rate" : leadInfo.customerRate,
                "industry" : leadInfo.industry,
                "assig_to" : leadInfo.assignedTo,
                "branch": leadInfo.branch,
                // MARK: - Contact Information
                "fname" : contactInfo.firstName,
                "lname" : contactInfo.lastName,
                "mobile phone" : contactInfo.phoneNumber,
                "contact_email" : contactInfo.contactEmail,
                "position" : contactInfo.position,
                // MARK: - Address Information
                "province":addressInfo.provinceId,
                "district":addressInfo.districtId,
                "commune":addressInfo.communeId,
                "village":addressInfo.villageId,
                "home":addressInfo.homeNumber,
                "street":addressInfo.streetNumber,
                "latlong":"\(addressInfo.lat ?? 0),\(addressInfo.lng ?? 0)"
            ]
        } else {
            parameters = [
                // MARK: - Lead Information
                "username" : username,
                "company_en" : leadInfo.compnayName,
                "company_kh" : leadInfo.customerName,
                "primary_phone" : leadInfo.primaryPhone,
                "vat_type" : leadInfo.vatType,
                "custo_type" : leadInfo.customerType,
                "custo_rate" : leadInfo.customerRate,
                "industry" : leadInfo.industry,
                "assig_to" : leadInfo.assignedTo,
                "branch": leadInfo.branch,
                // MARK: - Contact Information
                "fname" : contactInfo.firstName,
                "lname" : contactInfo.lastName,
                "mobile phone" : contactInfo.phoneNumber,
                "contact_email" : contactInfo.contactEmail,
                "position" : contactInfo.position,
                // MARK: - Address Information
                "province":addressInfo.provinceId,
                "district":addressInfo.districtId,
                "commune":addressInfo.communeId,
                "village":addressInfo.villageId,
                "home":addressInfo.homeNumber,
                "street":addressInfo.streetNumber,
                "latlong":"\(addressInfo.lat ?? 0),\(addressInfo.lng ?? 0)",
                "leadid": leadId
            ]
        }
        
//        print(leadId ?? "", " : at service")
        let url = leadId == nil ? APIManager.CRM.POST_CREATE_LEAD : APIManager.CRM.UPDATE_FULL_LEAD
        AF.request(url, method: .post, parameters: parameters).response { (response) in
//            print(response, response.data ?? "data default")
            guard let data = response.data else { return }
//            print(data)
            if let json = try? JSON(data: data) {
//                print(json)
                let message = leadId == nil ? json["insert"].stringValue : json["Edit"].stringValue
                completion(message, leadId == nil ? LeadDetail(json: json["result"][0]) : nil)
            }
        }
    }
    
    func postCreateLeadShortForm(username : String, firstName : String, lastName : String, phoneNumber : String, completion : @escaping(_ message : String)->()){
        let parameters = [
            "username" : username,
            "fname" : firstName,
            "lname" : lastName,
            "phone" : phoneNumber
        ]
        AF.request(APIManager.CRM.POST_CREATE_LEAD_SHORT, method: .post, parameters: parameters).response {(response) in
            guard let data = response.data else { return }
            if let json = try? JSON(data: data) {
                let message = json["MESSAGE"].stringValue
                completion(message)
            }
        }
    }
    
    func postConvertLead(username : String, status : String, leadId : String, completion : @escaping(_ message : String)->()){
        let parameters = [
            "username" : username,
            "status" : status,
            "leadid" : leadId
        ]
        
        AF.request(APIManager.CRM.POST_CONVERT_LEAD, method: .post, parameters: parameters).response{(response) in
            guard let data = response.data else { return }
            if let json = try? JSON(data: data) {
                let message = json["success"].stringValue
                print("my message : \(message)")
                completion(message)
            }
        }
    }
    
    func postRegisterPackageCRM (registerPackageCRM crm : RegisterPackageCRM, completion : @escaping(_ statusCode : Int)->()){
        let parameters = [
            "staff_name": "\(crm.userName ?? "monyoudom.bun")",
            "fname": "\(crm.fname ?? "")",
            "lname": "\(crm.lname ?? "")",
            "phone": "\(crm.phone ?? "")",
            "package": "\(crm.packageId ?? "")",
            "village": "\(crm.villageId ?? "")",
            "email": "\(crm.email ?? "")",
            "latlong": "\(crm.latlong ?? "")",
            "address": "\(crm.homeNStreetN ?? "")"
        ]
        AF.request(APIManager.CRM.POST_REGISTER_PACKAGE, method: .post , parameters: parameters).response { (response) in
            guard let data = response.data else { return }
            let json = try? JSON(data: data)
            if let json = json {
                if json["STATUS"].intValue == 200 {
                    completion(json["STATUS"].intValue)
                } else if json["MESSAGE"].stringValue == "invalid request" {
                    completion(0)
                }
            } else {
                completion(-1)
            }
            
        }
    }
    
    func updateLeadStatus(username : String, leadId : String, leadStatus : String, completion : @escaping(_ message : String)->Void){
        
        let parameters = [
            "username" : username,
            "leadid" : leadId,
            "status" : leadStatus
        ]
        
        AF.request(APIManager.CRM.UPDATE_STATUS, method: .post, parameters: parameters).response {(response) in
            guard let data = response.data else { return }
            let json = try? JSON(data: data)
            if let json = json {
                completion(json["message"].stringValue)
            }
        }
    }
    
    func postLeadToDo(username: String, leadId : String, assignTo : String, subject : String, startDate : String, endDate : String, completion : @escaping(_ message : String)->()){
        let parameters = [
            "username" : username,
            "leadid" : leadId,
            "assign_to" : assignTo,
            "subject" : subject,
            "startdate" : startDate,
            "enddate" : endDate
        ]
        AF.request(APIManager.CRM.POST_LEAD_TO_DO, method: .post, parameters: parameters).response {response in
            guard let data = response.data else { return }
            let json = try? JSON(data: data)
            if let json = json {
                print(json)
                completion(json["result"].stringValue)
//                completion(json["message"].stringValue)
            }
        }
    }
}
