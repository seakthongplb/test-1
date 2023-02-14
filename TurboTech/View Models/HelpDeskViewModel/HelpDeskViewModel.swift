//
//  HelpDeskViewModel.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

class HelpDeskViewModel {
    var helpDeskService = HelpDeskService()
    
    func postComplainMessage(complain : UserComplain, handler : @escaping(_ message : String)->()){
        helpDeskService.postComplainMessage(complain: complain) { (message) in
            if message == "Data Inserted Successfully" {
                handler("Thanks For Your Us Report Problem")
            }
            else {
                handler("Sorry")
            }
            
        }
    }
    
    func fetchAllFAQs(handler : @escaping(_ FAQsList : [SupportQuestion])->()){
        helpDeskService.fetchAllFAQs { (list) in
            handler(list)
        }
    }
    
    func fetchProblemType(completionHandler : @escaping(_ problemList : [ProblemType])->()){
        helpDeskService.fetchProblemType { (list) in
            completionHandler(list)
        }
    }
}
