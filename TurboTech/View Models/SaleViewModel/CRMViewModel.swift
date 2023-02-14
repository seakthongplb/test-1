//
//  CRMViewModel.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

class CRMViewModel {
    let crmService = CRMService()
    
    // MARK: - Fetch Data
    func fetchAllLeadByUsernameYearMonth(username : String, year : String, month : String, completion : @escaping(_ convert : Int, _ unconvert : Int, _ role : String?, _ list : [LeadAll])-> Void){
        crmService.fetchAllLeadByUsernameYearMonth(username: username, year: year, month: month) { (convert, unconvert, role, leadList) in
//            completion(convert, unconvert, role, self.sortLeadByStatus(leadList))
            completion(convert, unconvert, role, leadList)
        }
    }

    func fetchLeadByLeadId(id : String, completion : @escaping(_ message : String?, _ lead : Lead?)->Void){
        crmService.fetchLeadByLeadId(id: id){ (message, lead) in
            completion(message, lead)
        }
    }
    
    func fetchDropDownData(crmPickerEnum : CRMPickerEnum, completion : @escaping(_ list : [CRMPickerData])->()) {
        crmService.fetchDropDownData(crmPickerEnum: crmPickerEnum) { (list) in
            if crmPickerEnum == .assignedTo {
                if let fullname = AppDelegate.user?.fullName {
                    completion(self.moveOwnerToFirst(fullname, list))
                } else {
                    completion(list)
                }
            } else {
                completion(list)
            }
            
        }
    }
    
    func fetchRegisterPackage(completion : @escaping(_ packageList : [CRMPackage])->()){
        crmService.fetchRegisterPackage { (packageList) in
            completion(packageList)
        }
    }
    
    // MARK: - Post_Update
    func postCreateNewLead(username : String, leadId : String?, crmCustomerRegistration:CRMCustomerRegistration, completion : @escaping(_ message : String, _ lead : LeadDetail?)->()) {
//        print("Call View Model : ", leadId ?? "")
        crmService.postCreateNewLead(username: username, leadId: leadId, leadInfo: crmCustomerRegistration.crmLeadInformation!, contactInfo: crmCustomerRegistration.crmContactInformation!, addressInfo: crmCustomerRegistration.crmAddressInformation!) { (message, lead) in
//            print("Completion View Model")
            completion(message, lead)
        }
    }
    
    func postCreateLeadShortForm(username : String, firstName : String, lastName : String, phoneNumber : String, completion : @escaping(_ message : String)->()){
        crmService.postCreateLeadShortForm(username: username, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber) { (message) in
            completion(message)
        }
    }
    
    func postRegisterPackageCRM (registerPackageCRM crm : RegisterPackageCRM, completion : @escaping(_ code : Int, _ packageList : String)->()){
        crmService.postRegisterPackageCRM(registerPackageCRM: crm) { (code) in
            if code == 200 {
                completion(code, "register successfully".localized)
            } else {
                completion(code, "please try again !".localized)
            }
        }
    }
    
    func postConvertLead(username : String, status : String, leadId : String, completion : @escaping(_ message : String, _ status : Bool)->()){
        crmService.postConvertLead(username: username, status: status, leadId: leadId) { (message) in
            completion(message, message == "convert  success" ? true : false)
        }
    }
    
    func updateLeadStatus(username : String, leadId : String, leadStatus : String, completion : @escaping(_ message : String)->Void){
        crmService.updateLeadStatus(username: username, leadId: leadId, leadStatus: leadStatus) { (message) in
            completion(message)
        }
    }
    
    // MARK: - Customize Data
    
    func sortLeadByStatus(_ list : [LeadAll]) -> [LeadAll] {
        return list.filter{ $0.converted == false && $0.status != "" && ($0.status == "Cold" || $0.status == "Surveyed" || $0.status == "Qualified" || $0.status == "Junk Lead" || $0.status == "Inquiry") }.sorted(by: { $0.status < $1.status } )
    }
    
    func moveOwnerToFirst(_ name : String, _ list : [CRMPickerData]) -> [CRMPickerData] {
        if let index = list.firstIndex(where: {$0.name == name}) {
            let data = list[index]
            var newList = list
            newList.remove(at: index)
            newList.insert(data, at: 0)
            return newList
        } else {
            return list
        }
    }
    
    func postLeadToDo(username: String, leadId : String, assignTo : String, subject : String, startDate : Date, endDate : Date, completion : @escaping(_ message : String, _ status : Bool)->()){
        crmService.postLeadToDo(username: username, leadId: leadId, assignTo: assignTo, subject: subject, startDate: startDate.toString(toFormat: .yyyymdd), endDate: endDate.toString(toFormat: .yyyymdd)) { (message) in
            completion(message, message == "success" ? true : false)
        }
    }
}
