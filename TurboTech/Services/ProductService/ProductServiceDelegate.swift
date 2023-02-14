//
//  ServiceServiceDelegate.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

protocol ProductServiceDelegate {
    func responseProduct(products : [Product])
    func responsePackage(type : Int, packages : [Package])
    func responsePackageDetail(packageId : Int, packageDetails : [PackageDetail])
    func responseSoftwareSolution(solutions : [SoftwareSolution])
    func responseMessage(message : String)
}
