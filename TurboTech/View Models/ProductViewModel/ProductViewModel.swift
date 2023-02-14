//
//  File.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

class ProductViewModel {
    var productViewModelDelegate : ProductViewModelDelegate?
    var productService : ProductService?
    
    init(){
        productService = ProductService()
        productService?.productServiceDelegate = self
    }
    
    func postRegisterNewService(_ firstname : String, _ lastname : String, _ phone : String){
        productService?.postRegisterNewService(firstname, lastname, phone)
    }
    
    func fetchAllProducts(){
        productService?.fetchAllProducts()
    }
    
    func fetchAllPackage(type : Int){
        productService?.fetchAllPackage(type: type)
    }
    func fetchPackageDetail(packageId : Int){
        productService?.fetchPackageDetail(packageId: packageId)
    }
    func fetchSoftwareSolution(){
        productService?.fetchSoftwareSolution()
    }
}

extension ProductViewModel : ProductServiceDelegate {
    func responseMessage(message: String) {
        productViewModelDelegate?.responseMessage(message)
    }
    
    
    func responsePackageDetail(packageId: Int, packageDetails: [PackageDetail]) {
        productViewModelDelegate?.responsePackageDetail(packageDetails: filterPackageDetail(packageId: packageId, packageDetails: packageDetails))
    }
    
    func responseProduct(products : [Product]) {
        productViewModelDelegate?.responseProduct(products: products)
    }
    
    func responsePackage(type : Int, packages : [Package]){
        productViewModelDelegate?.responsePackage(packages: filterPackage(type: type, packages: packages))
    }
    
    func responseSoftwareSolution(solutions: [SoftwareSolution]) {
        productViewModelDelegate?.responseSoftwareSolution(solutions: solutions)
    }
    
    func filterPackage(type : Int, packages : [Package]) -> [Package]{
        var filter = [Package]()
        for package in packages {
            if package.productId == type {
                filter.append(package)
            }
        }
        return filter
    }
    
    func filterPackageDetail(packageId: Int, packageDetails: [PackageDetail]) -> [PackageDetail] {
        var filter = [PackageDetail]()
        for detail in packageDetails {
            if detail.packageId == packageId {
                detail.setDetailEn(str: String((detail.detailEn).dropFirst()))
                detail.setDetailEn(str: (detail.detailEn).replacingOccurrences(of: "▒", with: "\n\n"))
                detail.setDetailKh(str: String((detail.detailKh).dropFirst()))
                
                detail.setDetailKh(str: (detail.detailKh).replacingOccurrences(of: "&amp;", with: "&"))
                detail.setDetailKh(str: (detail.detailKh).replacingOccurrences(of: "\r\n", with: ""))
                detail.setDetailKh(str: (detail.detailKh).replacingOccurrences(of: "▒", with: "\n\n"))
                detail.setDetailKh(str: (detail.detailKh).replacingOccurrences(of: "&nbsp;", with: ""))
                
                filter.append(detail)
            }
        }
        return filter
    }
}
