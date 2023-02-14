//
//  CustomizeNavTab.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import UIKit

enum NAV {
    
    // Size
    static let HOME_NAV_TITLE_SIZE : CGFloat = 20
    
    // Colors
    static let HOME_NAV_COLOR_RED = UIColor.red
    static let HOME_NAV_COLOR_BLUE = UIColor.blue
    static let HOME_NAV_COLOR_WHITE = UIColor.white
}
enum TAB {
    static let COLOR = UIColor.red
    static let UNSELECTED_COLOR = UIColor.white
    static let UISELECTED_ALPHA : CGFloat = 0.5
    static let SELECTED_COLOR = UIColor.white
}

class CustomizeNavTab {
    
}

enum BOARD {
    static let HOME = "HomeStoryboard"
    static let MESSAGE = "MessageStoryboard"
    static let LOCATION = "LocationStoryboard"
    static let DEPARTMENT = "DepartmentStoryboard"
    static let ABOUTUS = "AboutUsStoryboard"
    static let MAIN = "Main"
}

enum CONTROLLER {
    static let ADMIN = "AdminTableViewControllerID"
    static let SALE = "SaleTableViewControllerID"
    static let FINANCE = "FinanceTableViewControllerID"
    static let PRODUCT = "ProductViewControllerID"
    static let POP_LOCATION = "PopLocationViewControllerID"
    static let DEVICE = "DeviceTableViewControllerID"
    static let ATTENDANCE = "AttendanceViewControllerID"
    static let REGISTER_SERVICE = "RegisterServiceViewControllerID"
}
