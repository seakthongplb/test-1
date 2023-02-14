//
//  HomeService.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HomeService {
    let headers : HTTPHeaders = APIManager.HEADER
    func fetchSliderImage(completion : @escaping(_ imageList : [HomeImage])->()){
        var homeImageList = [HomeImage]()
        AF.request("\(APIManager.HOME.GET_IMAGE)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let image = HomeImage(json: json)
                    homeImageList.append(image)
                }
            }
            completion(homeImageList)
        }
    }
}
