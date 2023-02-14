//
//  Department.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

enum DepartmentType : String {
    case ITD
    case FND
    case BSD
    case OPD
    case TOP = "Top Managment"
    case NONE
}

enum Position : String {
//    Top Management
    case vicePresident = "Advisor CEO"
    case ceo = "CEO"
    case assistantCEO = "Assistant CEO"
    
//    ITD
    case programmer = "Programmer"
    case nocOfficer = "NOC Officer"
    case technicalManager = "Technical Manager"
    
//    FND
    case accountant = "Accountant"
    case stockManager = "Stock Manager"
    case accountManager = "Account Manager"
    case financeManager = "Finance Manager"
    
//    BSD
    case salesManagerCRM = "Sales Manager"
    case saleManager = "Sale Manager"
    case keyAccountManager = "Key Account Manager"
        
    case salesAdmin = "Sales Admin"
    case saleAdmin = "Sale Admin"
    
    case seniorKeyAccountOfficer = "Senior Key Account Officer"
    case keyAccountOfficer = "Key Account Officer"
    case salePersonCRM = "Sale Person"
    
//    OPD
    case supportManager = "Support Manager"
    case technicalSupport = "Technical Support"
    case ospOfficer = "OSP Officer"
    case hrAndAdmin = "HR & Admin"
    case cablingTechnician = "Cabling Technician"
    case helpDeskAndSupport = "Helpdesk & Support"
    
//    Unknow
    case none 
}

enum Sale {
    case Product
    case Pop
    case Device
    case CRM
}

enum OPD {
    case CRM
    case ATTENDANCE
}

class Department {
    let id : Int
    let name : String
    let image : String
    var department : DepartmentType?
    var position : Position?
    var sale : Sale?
    var opd : OPD?
    
    init(id : Int, name : String, image : String, department : DepartmentType){
        self.id = id
        self.name = name
        self.image = image
        self.department = department
//        self.position = position
    }
    
    init(id : Int, name : String, image : String, sale : Sale){
        self.id = id
        self.name = name
        self.image = image
        self.sale = sale
    }
    
    init(id : Int, name : String, image : String, opd : OPD){
        self.id = id
        self.name = name
        self.image = image
        self.opd = opd
    }
}
