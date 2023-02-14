//
//  ServiceService.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProductService {
    var productServiceDelegate : ProductServiceDelegate?
    let headers : HTTPHeaders = APIManager.HEADER
    
    func postRegisterNewService(_ firstname : String, _ lastname : String, _ phone : String){
        let parameters = [
            "fname" : firstname,
            "lname" : lastname,
            "phone" : phone
        ]
        AF.request(APIManager.PACKAGE.POST_REGISTER_NEW_PACKAGE_BY_USER, method: .post, parameters: parameters, headers: headers).response {(response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data) {
                self.productServiceDelegate?.responseMessage(message: jsons["MESSAGE"].stringValue)
            }
        }
    }
    
    func fetchAllProducts(){
        var products = [Product]()
        AF.request("\(APIManager.PRODUCT.GET)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let pro = Product(json: json)
                    products.append(pro)
                }
            }

            self.productServiceDelegate?.responseProduct(products: products)
        }
    }
    
    func fetchAllPackage(type : Int){
        var packages = [Package]()
        AF.request("\(APIManager.PACKAGE.GET)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let package = Package(json: json)
                    packages.append(package)
                }
            }
            
            self.productServiceDelegate?.responsePackage(type : type, packages: packages)
        }
    }
    
    func fetchPackageDetail(packageId : Int){
        var details = [PackageDetail]()
        AF.request("\(APIManager.PACKAGE.GET_DETAIL)?package_id=\(packageId)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let package = PackageDetail(json: json)
                    details.append(package)
                }
            }
            self.productServiceDelegate?.responsePackageDetail(packageId : packageId, packageDetails: details)
        }
    }
    
    func fetchSoftwareSolution(){
        var softwareList = [SoftwareSolution]()
        AF.request("\(APIManager.PACKAGE.GET_SOFTWARE_SOLUTIOLN)", method: .get, headers: headers).response { (response) in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data){
                for json in jsons["result"].arrayValue {
                    let software = SoftwareSolution(json: json)
                    softwareList.append(software)
                }
            }
            self.productServiceDelegate?.responseSoftwareSolution(solutions: softwareList)
        }
    }
}
