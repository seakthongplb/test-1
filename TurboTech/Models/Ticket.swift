//
//  Ticket.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol PickerData {
    var name : String { get set }
}

class TicketAdminChart {
    var departmentFND : Double
    var departmentBSD : Double
    var departmentITD : Double
    var departmentOPD : Double
    var departmentTOP : Double
    var open : Double
    var waitForResponse : Double
    var inProgress : Double
    var closed : Double
    
    init(json: JSON){
        self.departmentFND = json["department_FND"].doubleValue
        self.departmentBSD = json["department_BSD"].doubleValue
        self.departmentITD = json["department_ITD"].doubleValue
        self.departmentOPD = json["department_OPD"].doubleValue
        self.departmentTOP = json["department_TOP"].doubleValue
        self.open = json["open"].doubleValue
        self.waitForResponse = json["wait_for_response"].doubleValue
        self.inProgress = json["in_progress"].doubleValue
        self.closed = json["closed"].doubleValue
    }
}

class TicketReport {
    var name : String
    var value : Double
    init(name : String, value : Double){
        self.name = name
        self.value = value
    }
    init(json : JSON) {
        self.name = json["name"].stringValue
        self.value = json["value"].doubleValue
    }
}

class TicketNotification {
    var ticket_id : String = ""
    var ticket_number : String
    var subject : String
    var organizationid : String = ""
    var organization_name : String
    var contactid : String = ""
    var contact_name : String
    var productid : String = ""
    var productname : String = ""
    var category : String
    var severity : String
    var status : String
    var description : String
    var assigned_to : String
    var create_time : String = ""
    var modified_time : String = ""
    var user : String = ""
    var imageUrl : String = ""

    init(json : JSON){
        self.ticket_id = json["ticket_id"].stringValue
        self.ticket_number = json["ticket_number"].stringValue
        self.subject = json["subject"].stringValue
        self.organizationid = json["organizationid"].stringValue
        self.organization_name = json["organization_name"].stringValue
        self.contactid = json["contactid"].stringValue
        self.contact_name = json["contact_name"].stringValue
        self.productid = json["productid"].stringValue
        self.productname = json["productname"].stringValue
        self.category = json["category"].stringValue
        self.severity = json["severity"].stringValue
        self.status = json["status"].stringValue
        self.description = json["description"].stringValue
        self.assigned_to = json["assigned_to"].stringValue
        self.create_time = json["create_time"].stringValue
        self.modified_time = json["modified_time"].stringValue
        self.user = json["user"].stringValue
    }
    
    init(ticketNumber : String = "" ,subject : String, decription : String, contactName : String, organization : String, severity : String, category : String, assignedTo : String, status : String = "Open"){
        self.ticket_number = ticketNumber
        self.subject = subject
        self.organization_name = organization
        self.contact_name = contactName
        self.category = category
        self.status = status
        self.assigned_to = assignedTo
        self.severity = severity
        self.description = decription
        
    }
}

class TicketHistory {
    var mode : String
    var user : String
    var modifiedTime : String
    var field : String
    var from  : String
    var to  : String

    init (json : JSON){
        self.mode = json["mode"].stringValue
        self.user = json["user"].stringValue
        self.modifiedTime = json["modified_time"].stringValue
        self.field = json["field"].stringValue
        self.from  = json["from "].stringValue
        self.to  = json["to "].stringValue
    }
}

class TicketOrganization : PopUpSearchProtocol {
    var id : Int
    var cId : String
    var organizationNo : String
    var name : String
    var customerName : String
    var vatType : String
    var customerType : String
    var phoneNumber : String
    var email : String
    var assignedTo : String
    var isSelected: Bool
    init(json : JSON){
        self.id = json["id"].intValue
        self.cId = json["CID"].stringValue
        self.organizationNo = json["organ_no"].stringValue
        self.name = json["organ_name"].stringValue
        self.customerName = json["customer_name"].stringValue
        self.vatType = json["vat_type"].stringValue
        self.customerType = json["customer_type"].stringValue
        self.phoneNumber = json["phone"].stringValue
        self.email = json["email"].stringValue
        self.assignedTo = json["Assgined_to"].stringValue
        self.isSelected = false
    }
}

class TicketStatus  : PickerData {
    var id: Int
    var name: String
    init(json : JSON){
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }
}

class TicketCategory  : PickerData {
    var id: Int
    var name: String
    init(json : JSON){
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }
}

class TicketSeverity : PickerData {
    var id: Int
    var name: String
    init(json : JSON){
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }
}

class TicketProduct {
    var id: Int
    var name: String
    var unitPrice : Double
    var commissionRate : Double
    var quantity : Int
    init(json : JSON){
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.unitPrice = json["unit_price"].doubleValue
        self.commissionRate = json["commission Rate"].doubleValue
        self.quantity = json["qty"].intValue
    }
}

class TicketContact : PopUpSearchProtocol {
    var id : Int
    var accountId : Int
    var contactNo : String
    var firstName : String
    var lastName : String
    var name : String
    var organization : String
    var email : String
    var province : String
    var country : String
    var isSelected: Bool
    init(json : JSON){
        self.id = json["id"].intValue
        self.accountId = json["accoun_id"].intValue
        self.contactNo = json["contact_no"].stringValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.name = json["Full_names"].stringValue
        self.organization = json["organization"].stringValue
        self.email = json["eamil"].stringValue
        self.province = json["province"].stringValue
        self.country = json["country"].stringValue
        self.isSelected = false
    }
}

class TicketUser  : PickerData{
    var id : Int
    var name : String
    init(json : JSON){
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
    }
    init(id : Int, name : String){
        self.id = id
        self.name = name
    }
}

enum TicketStatusEnum : String {
    case open = "open"
    case progress = "progress"
    case waiting = "wait for response"
    case closed = "closed"
}

enum TicketSeverityEnum : String {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
}

//enum TicketCreator {
//    case helpDesk
//    case headOfficer
//    case officer
//    case admin
//    case other
//}
