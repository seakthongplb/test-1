//
//  ServiceViewModelDelegate.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
// 

import Foundation

protocol ProductViewModelDelegate {
    func responseProduct(products : [Product])
    func responsePackage(packages : [Package])
    func responsePackageDetail(packageDetails : [PackageDetail])
    func responseSoftwareSolution(solutions : [SoftwareSolution])
    func responseMessage(_ message : String)
}
