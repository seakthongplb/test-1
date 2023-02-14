//
//  Ticket.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TicketService {
    let headers : HTTPHeaders = APIManager.HEADER
    
    
    
    func fetchImage(_ name : String, completion : @escaping(_ url : String)->()) {
        AF.request(APIManager.TICKET.GET_TICKET_IMAGE_URL+"?username=\(name)", method: .get).response{ response in
            guard let data = response.data else { return }
            if let json = try? JSON(data: data){
                completion(APIManager.IMAGE_PRO+json["image"].stringValue)
            }
        }
    }
    
    func getAdminChartTicket(month : String, year : String, completion : @escaping((_ data : TicketAdminChart)->())){
        AF.request(APIManager.TICKET.GET_TICKET_CHART+"?month=\(month)&year=\(year)", method: .get).response{(response) in
            guard let data = response.data else { return }
            if let json = try? JSON(data: data) {
                completion(TicketAdminChart(json: json["result"]))
            }
        }
    }
    
    func getTicketByDeptYearMonth(_ dept : String, _ year : Int, _ month: Int, _ completion : @escaping(([TicketNotification])->())){
        var ticketList = [TicketNotification]()
        AF.request("\(APIManager.TICKET.GET_TICKET_BY_DEPT)?depart=\(dept)&month=\(month)&year=\(year)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let ticket = TicketNotification(json: json)
                    ticketList.append(ticket)
                }
            }
            completion(ticketList)
        }
    }
    
    func getTicketNotification(_ username : String, _ year : Int, _ month : Int, _ status : String, completion : @escaping(([TicketNotification])->())){
        var ticketList = [TicketNotification]()
        AF.request("\(APIManager.TICKET.GET_TICKET)?username=\(username)&month=\(month)&year=\(year)&status=\(status)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let ticket = TicketNotification(json: json)
                    ticketList.append(ticket)
                }
            }
            completion(ticketList)
        }
    }
    
    func getTicketHistory(ticketId : String, _ completion : @escaping(([TicketHistory])->Void)){
        var list = [TicketHistory]()
        AF.request(APIManager.TICKET.GET_TICKET_HISTORY+"?ticketid=\(ticketId)", method: .get, headers: headers).response{ response in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data) {
                print(jsons)
                for json in jsons["history"].arrayValue {
                    let history = TicketHistory(json: json)
                    list.append(history)
                }
            }
            completion(list)
        }
    }
    
    func getTicketNotification(_ username : String, _ year : Int, _ month : Int, completion : @escaping(([TicketNotification])->())){
        var ticketList = [TicketNotification]()
        AF.request("\(APIManager.TICKET.GET_TICKET)?username=\(username)&month=\(month)&year=\(year)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let ticket = TicketNotification(json: json)
                    ticketList.append(ticket)
                }
            }
            completion(ticketList)
        }
    }
    
    func postTicket(username: String, subject : String, contact : Int, organization : Int, serverity : String, category : String, assign_to : Int, description : String, completion : @escaping()->()){
        let parameters = [
            "username": username,
            "subject" : subject,
            "contact" : contact,
            "organization" : organization,
            "serverity" : serverity,
            "category" : category,
            "assign_to" : assign_to,
            "description" : description
            ] as [String : Any]
        AF.request(APIManager.TICKET.POST_NEW_TICKET_HELP_DESK, method: .post, parameters: parameters).response{ response in
            guard let data = response.data else { return }
            let json = try? JSON(data: data)
            if let _ = json {
                completion()
            }
        }
    }
    
    func postTicket(username : String, subject : String, contactId : Int, organizationId : Int, severity : String, category : String, completion : @escaping(_ status : String) -> ()){
        let parameters = [
            "username": username,
            "subject" : subject,
            "contact" : "\(contactId)",
            "organization" : "\(organizationId)",
            "severity" : severity,
            "category" : category
        ]
        
        AF.request(APIManager.TICKET.POST_NEW_TICKET, method: .post , parameters: parameters).response { (response) in
            guard let data = response.data else { return }
            let json = try? JSON(data: data)
            if let json = json {
                completion(json["insert"].stringValue)
            } else {
                completion("")
            }
            
        }
    }
    
    func postTicket(username : String, ticket : TicketNotification, _ completion : @escaping(_ status : Bool, _ message : String?)->()){
        var parameters = [String : Any]()
        if ticket.ticket_number == "" {
            // Create new ticket
            if ticket.assigned_to == "" {
                parameters = [
                    "username" : username,
                    "subject" : ticket.subject,
                    "contact" : ticket.contact_name,
                    "organization" : ticket.organization_name,
                    "category" : ticket.category,
                    "severity" : ticket.severity,
                    "description" : ticket.description
                ]
            } else {
                parameters = [
                    "username" : username,
                    "subject" : ticket.subject,
                    "contact" : ticket.contact_name,
                    "organization" : ticket.organization_name,
                    "category" : ticket.category,
                    "severity" : ticket.severity,
                    "description" : ticket.description,
                    "assigned_to" : ticket.assigned_to
                ]
            }
        } else {
            parameters = [
                "ticketid" : ticket.ticket_number,
                "username" : username,
                "subject" : ticket.subject,
                "contact" : ticket.contact_name,
                "organization" : ticket.organization_name,
                "category" : ticket.category,
                "severity" : ticket.severity,
                "assigned_to" : ticket.assigned_to,
                "description" : ticket.description,
                "status" : ticket.status
            ]
        }
        
        print("បានដំណើរការ #០០១")
        parameters.forEach { (សោរ, តម្លៃ) in
            print("សោរ : \(សោរ) = តម្លៃ : \(តម្លៃ)")
        }
        
        let url = ticket.ticket_number == "" ? APIManager.TICKET.POST_NEW_TICKET : APIManager.TICKET.POST_EDIT_TICKET
        AF.request(url, method: .post , parameters: parameters).response { (response) in
            guard let data = response.data else { return }
            let json = try? JSON(data: data)
            if let json = json {
                print(json)
                completion(true, json[ticket.ticket_number == "" ? "insert" : "Edit"].stringValue)
            } else {
                completion(false, "fail".localized)
            }
            
        }
    }
    
    func postEditTicket(username : String, status : String, ticketId : String, complention : @escaping(_ status : String) -> ()){
        let paramteters = [
            "username" : username,
            "status" : status,
            "ticket" : ticketId
        ]
        
        AF.request(APIManager.TICKET.POST_EDIT_TICKET_STATUS, method: .post, parameters: paramteters).response { (resposne) in
            guard let data = resposne.data else { return }
            let json = try? JSON(data: data)
            if let json = json {
                complention(json["message"].stringValue)
            } else {
                complention("")
            }
        }
    }
    func fetchTicket(username : String, month : Int, year : Int, status : String, completion : @escaping(_ packageList : [TicketNotification])->()){
        var ticketList = [TicketNotification]()
        AF.request("\(APIManager.TICKET.GET_TICKET)?username=\(username)&month=\(month)&year=\(year)&status=\(status)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let ticket = TicketNotification(json: json)
                    ticketList.append(ticket)
                }
            }
            completion(ticketList)
        }
    }
    
    func fetchServerity(completion : @escaping(_ packageList : [TicketSeverity])->()){
        var ticketList = [TicketSeverity]()
        AF.request("\(APIManager.TICKET.GET_SEVERITY)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let ticket = TicketSeverity(json: json)
                    ticketList.append(ticket)
                }
            }
            completion(ticketList)
        }
    }
    
    func fetchStatus(completion : @escaping(_ packageList : [TicketStatus])->()){
        var ticketList = [TicketStatus]()
        AF.request("\(APIManager.TICKET.GET_STATUS)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let ticket = TicketStatus(json: json)
                    ticketList.append(ticket)
                }
            }
            completion(ticketList)
        }
    }
    
    func fetchCategory(completion : @escaping(_ packageList : [TicketCategory])->()){
        var ticketList = [TicketCategory]()
        AF.request("\(APIManager.TICKET.GET_CATEGORY)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let ticket = TicketCategory(json: json)
                    ticketList.append(ticket)
                }
            }
            completion(ticketList)
        }
    }
    
    func fetchProduct(completion : @escaping(_ packageList : [TicketProduct])->()){
        var ticketList = [TicketProduct]()
        AF.request("\(APIManager.TICKET.GET_PRODUCT)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let ticket = TicketProduct(json: json)
                    ticketList.append(ticket)
                }
            }
            completion(ticketList)
        }
    }
    
    func fetchContact(completion : @escaping(_ packageList : [TicketContact])->()){
        var ticketList = [TicketContact]()
        AF.request("\(APIManager.TICKET.GET_CONTACT)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let ticket = TicketContact(json: json)
                    ticketList.append(ticket)
                }
            }
            completion(ticketList)
        }
    }
    
    func fetchOrganization(completion : @escaping(_ packageList : [TicketOrganization])->()){
        var ticketList = [TicketOrganization]()
        AF.request("\(APIManager.TICKET.GET_ORGANIZATION)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let ticket = TicketOrganization(json: json)
                    ticketList.append(ticket)
                }
            }
            completion(ticketList)
        }
    }
    
    func fetchUser(completion : @escaping(_ packageList : [TicketUser])->()){
        var ticketList = [TicketUser]()
        AF.request("\(APIManager.TICKET.GET_USER)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let ticket = TicketUser(json: json)
                    ticketList.append(ticket)
                }
            }
            completion(ticketList)
        }
    }
    
    func fetchUser(department : String, _ completion : @escaping(_ packageList : [TicketUser])->()){
        var tickerUserList = [TicketUser]()
        print("\(APIManager.TICKET.GET_USER_BY_DEPT)?depart=\(department)")
        AF.request("\(APIManager.TICKET.GET_USER_BY_DEPT)?depart=\(department)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                print(jsons)
                for json in jsons["result"].arrayValue {
                    let ticket = TicketUser(json: json)
                    tickerUserList.append(ticket)
                }
                completion(tickerUserList)
            }
        }
    }
}

