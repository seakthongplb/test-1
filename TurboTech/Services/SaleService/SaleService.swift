//
//  SaleService.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SaleService {
    
    let headers : HTTPHeaders = APIManager.HEADER
    
    func fetchAllPop(handler : @escaping(_ FAQsList : [POP])->()){
        var popList = [POP]()
        AF.request("\(APIManager.SALE.GET_POP)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let pop = POP(json: json)
                    popList.append(pop)
                }
            }
            handler(popList)
        }
    }
    
    func fetchPopDetailByPopId(id : Int, handler: @escaping(_ popDetailList : [PopDetail])->()){
        var list = [PopDetail]()
        AF.request(APIManager.SALE.GET_POP_DETAIL + "\(id)", method: .get, headers: headers).response{ (respsone) in
            guard let data = respsone.data else { return }
            if let jsons = try? JSON(data: data) {
//                print(jsons)
                for json in jsons["result"].arrayValue {
                    let detail = PopDetail(json: json)
                    list.append(detail)
                }
            }
            handler(list)
        }
    }
    
    func fetchDevices(completionHandler : @escaping(_ deviceList : [Device])->()){
        var devices = [Device]()
        AF.request("\(APIManager.SALE.GET_DEVICE)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let device = Device(json: json)
                    devices.append(device)
                }
            }
            completionHandler(devices)
        }
    }
    
    func fetchAddress(addressType : ADDRESS, id : String?, completionHandler : @escaping(_ addresList : [Address])->()){
        var url : String = ""
        switch addressType {
        case .province :
            url = APIManager.ADDRESS.PROVINCE
        case .district :
            url = APIManager.ADDRESS.DISTRICT + "\(id ?? "")"
        case .commune :
            url = APIManager.ADDRESS.COMMUNE + "\(id ?? "")"
        case .village :
            url = APIManager.ADDRESS.VILLAGE + "\(id ?? "")"
        }
        var addrList = [Address]()
//        print(url)
        AF.request(url, method: .get, headers: headers).response{(response)in
            guard let data = response.data else {return}
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let addr = Address(json: json)
                    addrList.append(addr)
                }
            }
            completionHandler(addrList)
        }
    }
    
    func fetchPopInnerDetail(popId : String, _ completion : @escaping(_ result : PopInnerDetail)->()){
        AF.request(APIManager.SALE.GET_POP_DETAIL + popId, method: .get).response{ response in
            guard let data = response.data else { return }
            if let json = try? JSON(data: data) {
                completion(PopInnerDetail(json: json))
            }
        }
    }
    
}
