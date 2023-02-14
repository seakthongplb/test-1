//
//  TicketViewModel.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

class TicketViewModel {
    var ticketService = TicketService()
    
    func getAdminChartTicket(month : String, year : String, completion : @escaping((_ data : TicketAdminChart)->())){
        ticketService.getAdminChartTicket(month: month, year: year) { (data) in
            completion(data)
        }
    }
    
    func getTicketByDeptYearMonth(_ dept : String, _ year : Int, _ month: Int, _ completion : @escaping(([TicketNotification])->())){
        ticketService.getTicketByDeptYearMonth(dept, year, month) { (list) in
            self.setUserImage(data: list) { (data) in
                completion(data)
            }
        }
    }
    
    func getTicketNotification(_ username : String, _ year : Int, _ month : Int, _ status : String, completion : @escaping(([TicketNotification])->())){
        ticketService.getTicketNotification(username, year, month, status) { (list) in
            completion(list)
        }
    }
    
    func getTicketNotification(_ username : String, _ year : Int, _ month : Int, completion : @escaping(([TicketNotification])->())){
        ticketService.getTicketNotification(username, year, month) { (list) in
            completion(list)
        }
    }
    
    func getTicketHistory(ticketId : String, _ completion : @escaping(([TicketHistory])->Void)){
        self.ticketService.getTicketHistory(ticketId: ticketId) { (list) in
            completion(list)
        }
    }
    
    func postTicket(username: String, subject : String, contact : Int, organization : Int, serverity : String, category : String, assign_to : Int, description : String, completion : @escaping()->()){
        ticketService.postTicket(username: username, subject: subject, contact: contact, organization: organization, serverity: serverity, category: category, assign_to: assign_to, description: description) {
            completion()
        }
    }
    
    func postTicket(username : String, subject : String, contactId : Int, organizationId : Int, severity : String, category : String, completion : @escaping(_ status : Bool) -> ()){
        ticketService.postTicket(username: username, subject: subject, contactId: contactId, organizationId: organizationId, severity: severity, category: category) { (message) in
            if message == "Success" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func postTicket(ticket : TicketNotification, _ completion : @escaping(_ status : Bool, _ message : String?)->()) {
        guard let username = AppDelegate.user?.userName else { return }
        ticketService.postTicket(username: username, ticket: ticket) { (status, message) in
            completion(status, message)
        }
    }
    
    func postEditTicket(username : String, status : String, ticketId : String, complention : @escaping(_ status : Bool) -> ()){
        ticketService.postEditTicket(username: username, status: status, ticketId: ticketId) { (message) in
            if message == "" || message == "do not have Ticket" {
                complention(false)
            } else {
                complention(true)
            }
        }
    }
    
    func fetchTicket(username : String, month : Int, year : Int, status : String, completion : @escaping(_ packageList : [TicketNotification])->()){
        ticketService.fetchTicket(username: username, month: month, year: year, status: status) { (tickets) in
            completion(tickets)
        }
    }
    
    func fetchServerity(completion : @escaping(_ packageList : [TicketSeverity])->()){
        ticketService.fetchServerity { (tickets) in
            completion(tickets)
        }
    }
    
    func fetchStatus(completion : @escaping(_ packageList : [TicketStatus])->()){
        ticketService.fetchStatus { (tickets) in
            completion(tickets)
        }
    }
    
    func fetchCategory(completion : @escaping(_ packageList : [TicketCategory])->()){
        ticketService.fetchCategory { (tickets) in
            completion(tickets)
        }
    }
    
    func fetchProduct(completion : @escaping(_ packageList : [TicketProduct])->()){
        ticketService.fetchProduct { (tickets) in
            completion(tickets)
        }
    }
    
    func fetchContact(completion : @escaping(_ packageList : [TicketContact])->()){
        ticketService.fetchContact { (tickets) in
            completion(tickets)
        }
    }
    
    func fetchOrganization(completion : @escaping(_ packageList : [TicketOrganization])->()){
        ticketService.fetchOrganization { (tickets) in
            completion(tickets)
        }
    }
    
    func fetchUser(completion : @escaping(_ packageList : [TicketUser])->()){
        ticketService.fetchUser { (tickets) in
            completion(tickets)
        }
    }
    
    func fetchUser(department : String, _ completion : @escaping(_ packageList : [TicketUser])->()){
        ticketService.fetchUser(department: department) { (list) in
            print("THIS IS WORK")
            completion(list)
        }
    }
    
    func setUserImage(data : [TicketNotification], _ completion : @escaping(_ data : [TicketNotification])->()){
        DispatchQueue.main.async {
            data.forEach { (ticket) in
                self.ticketService.fetchImage(ticket.user, completion: { (url) in
                    ticket.imageUrl = url
                })
            }
            completion(data)
        }
    }
}
