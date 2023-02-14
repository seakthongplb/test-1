//
//  CRM.swift
//  TurboTech
//
//  Created by sq on 6/30/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

class CRMCustomerRegistration {
    var crmLeadInformation : CRMLeadInformation?
    var crmContactInformation : CRMContactInformation?
    var crmAddressInformation : CRMAddressInformation?
}

struct CRMLeadInformation {
    var compnayName : String?
    var customerName : String?
    var primaryPhone : String?
    var vatType : String?
    var customerType : String?
    var customerRate : String?
    var industry : String?
    var assignedTo : String?
    var leadSource : String?
    var branch : String?
}

struct CRMContactInformation {
    var firstName : String?
    var lastName : String?
    var phoneNumber : String?
    var contactEmail : String?
    var position : String?
}

struct CRMAddressInformation {
    var provinceId : String?
    var districtId : String?
    var communeId : String?
    var villageId : String?
    var homeNumber : String?
    var streetNumber : String?
    var lat : Double?
    var lng : Double?
}

class CRMPickerData {
    var id : Int
    var name : String
    init(json : JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }
    init(_ id : Int, _ name : String) {
        self.id = id
        self.name = name
    }
}

enum CRMPickerEnum {
    case vatType
    case customerType
    case customerRate
    case industry
    case assignedTo
    case branch
    case leadStatus 
}



// MARK: - ALl Lead
class LeadAll {
    var leadId : String
    var custmerName : String
    var assignTo : String
    var status : String
    var converted : Bool
    
    init(json : JSON){
        self.leadId = json["lead_id"].stringValue
        self.custmerName = json["customer_name"].stringValue
        self.assignTo = json["assign_to"].stringValue
        self.status = json["status"].stringValue
        let con = json["converted"].intValue
        self.converted = con == 0 ? false : true
    }
}

class Lead {
    var leadDetail : LeadDetail
    var userCreateLead : UserCreatedLead
    var leadHistories = [LeadHistory]()
    init(json : JSON){
        self.leadDetail = LeadDetail(json: json["detail lead"])
        self.userCreateLead = UserCreatedLead(json: json["user create"])
        for js in json["history"].arrayValue {
            self.leadHistories.append(LeadHistory(json: js))
        }
    }
}

class LeadDetail {
    var userCreateLead : String?
    var createTime : String?
    var leadNumber : String?
    var companyName : String?
    var companyKh : String?
    var leadPhone : String?
    var primaryEmail : String?
    var contactPhone : String?
    var currentSpeed : String?
    var currentPrice : String?
    var leadSource : String?
    var leadStatus : String?
    var assigTo : String?
    var firstName : String?
    var lastName : String?
    var nationalIdCard : String?
    var passportId : String?
    var contactEmail : String?
    var position : String?
    var cusRatingType : String?
    var cusType : String?
    var priority : String?
    var branch : String?
    var industry : String?
    var modifiedTime : String?
    var address : String?
    var mapcode : String?
    var homeEN : String?
    var homekh : String?
    var home : String?
    var street : String?
    var vatType : String?
    var addressCode : String?
    var province : String?
    var district : String?
    var commune : String?
    var village : String?
    var lat : Double?
    var lng : Double?
    
    init(json : JSON){
        userCreateLead = json["user_create_lead"].stringValue
        createTime = json["create_time"].stringValue
        leadNumber = json["lead_number"].stringValue
        companyName = json["conpany_name"].stringValue
        companyKh = json["company_kh"].stringValue
        leadPhone = json["lead_phone"].stringValue
        primaryEmail = json["primary_email"].stringValue
        contactPhone = json["contact_phone"].stringValue
        currentSpeed = json["current_speed"].stringValue
        currentPrice = json["current_price"].stringValue
        leadSource = json["lead_source"].stringValue
        leadStatus = json["lead_status"].stringValue
        assigTo = json["assig_to"].stringValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        nationalIdCard = json["national_ID_card"].stringValue
        passportId = json["passport_ID"].stringValue
        contactEmail = json["contact_email"].stringValue
        position = json["position"].stringValue
        cusRatingType = json["cus_rating_type"].stringValue
        cusType = json["cus_type"].stringValue
        priority = json["priority"].stringValue
        branch = json["branch"].stringValue
        industry = json["industry"].stringValue
        modifiedTime = json["modified_time"].stringValue
        address = json["address"].stringValue
        mapcode = json["mapcode"].stringValue
        homeEN = json["homeEN"].stringValue
        homekh = json["homekh"].stringValue
        home = json["home"].stringValue
        street = json["street"].stringValue
        vatType = json["vat_type"].stringValue
        addressCode = json["addressCode"].stringValue
        province = json["province"].stringValue
        district = json["district"].stringValue
        commune = json["commune"].stringValue
        village = json["village"].stringValue
        let latlong = self.mapcode?.components(separatedBy: ",")
        if latlong?.count == 2 {
            lat = Double(latlong?[0] ?? "0.0")
            lng = Double(latlong?[1] ?? "0.0")
        }
        
    }
}

class UserCreatedLead {
    var mode : String
    var user : String
    var createdAt : String
    
    init(json : JSON){
        self.mode = json["mode"].stringValue
        self.user = json["user"].stringValue
        self.createdAt = json["create_time"].stringValue
    }
}

class LeadHistory {
    var mode : String
    var user : String
    var modifiedTime : String
    var field : String
    var from : String
    var to : String

    init(json : JSON){
        self.mode = json["mode"].stringValue
        self.user = json["user"].stringValue
        self.modifiedTime = json["modified_time"].stringValue
        self.field = json["field "].stringValue
        self.from = json["from "].stringValue
        self.to = json["to "].stringValue
    }
}

enum LeadStatus : String {
    case overall = "Overall"
    case cold = "Cold"
    case surveyed = "Surveyed"
    case qualified = "Qualified"
    case junkLead = "Junk Lead"
    case inquiry = "Inquiry"
}
