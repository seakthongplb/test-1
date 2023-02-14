//
//  SaleViewModel.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

class SaleViewModel {
    
    let saleService = SaleService()
    
    func fetchAllPop(handler : @escaping(_ FAQsList : [POP])->()){
        saleService.fetchAllPop { (popList) in
            handler(popList)
        }
    }
    
    func fetchPopDetailByPopId(id : Int, handler: @escaping(_ popDetailList : [PopDetail])->()){
        saleService.fetchPopDetailByPopId(id: id) { (list) in
            handler(list)
        }
    }
    
    func fetchDevices(completionHandler : @escaping(_ deviceList : [Device])->()){
        saleService.fetchDevices { (devices) in
            completionHandler(devices)
        }
    }
    
    func fetchAddress(addressType : ADDRESS, id : String?, completionHandler : @escaping(_ addresList : [Address])->()){
        saleService.fetchAddress(addressType: addressType, id: id) { (list) in
            completionHandler(list)
        }
    }
    
    func fetchPopInnerDetail(popId : String, _ completion : @escaping(_ popInnerDetail : PopInnerDetail)->()){
        saleService.fetchPopInnerDetail(popId: popId) { (popDetail) in
            print(popDetail.popContact.contactName)
            print(popDetail.popCustomer.count)
            print(popDetail.popProduct.count)
            completion(popDetail)
        }
    }
}
