//
//  Attendance.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Attendance {
    var id : Int { get }
    var name : String { get }
}

class AttendancePresent : Attendance {
    var id : Int
    var name : String
    var stateName : String
    var typeName : String
    var date : String
    var time : String
    var stamp : String
    
    init(json : JSON){
        self.id = json["ID"].intValue
        self.name = json["NAME"].stringValue
        self.stateName = json["STATE_NAME"].stringValue
        self.typeName = json["TYPE_NAME"].stringValue
        self.date = json["DATE"].stringValue
        self.time = json["TIME"].stringValue
        self.stamp = json["STAMP"].stringValue
    }
}

class AttendanceAbsence : Attendance {
    var id : Int
    var name : String
    var userId : Int
    var approver : String
    var editor : String
    init(json: JSON){
        self.id = json["ID"].intValue
        self.name = json["NAME"].stringValue
        self.userId = json["USER_ID"].intValue
        self.approver = json["APPROVE"].stringValue
        self.editor = json["UPDATE_BY"].stringValue
    }
}

class Mission {
    var type : String
    var reason : String
    var shift : String
    var staffIdNumber : String
    var userId : String
    var fromDate : String?
    var toDate : String?
    
    init(type : String, reason : String, shift : String, staffIdNumber : String, userId : String, fromDate : String?, toDate : String?) {
        self.type = type
        self.reason = reason
        self.shift = shift
        self.staffIdNumber = staffIdNumber
        self.userId = userId
        self.fromDate = fromDate
        self.toDate = toDate
    }
}

class LateException {
    var isException : Bool
    var description : String
    var maUserId : String
    var userId : String

    init(isException : Bool, description : String, maUserId : String, userId : String){
        self.isException = isException
        self.description = description
        self.maUserId = maUserId
        self.userId = userId
    }
}

class Permission {
    var userId : String
    var editorId : String
    var approveBy : String
    var reason : String?
    var dateFrom : String
    var dateTo : String
    var leaveType : Int?

    init(userId : String, editorId : String, approvedBy : String, reason : String?, dateFrom : String, dateTo : String, leaveType : Int?){
        self.userId = userId
        self.editorId = editorId
        self.approveBy = approvedBy
        self.reason = reason
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.leaveType = leaveType
    }
}

class MyAttendanceDetail {
    var dayOfWeek : String = ""
    var amIn : String
    var amOut : String
    var pmIn : String
    var pmOut : String
    var date : String
    var isSunday : Bool
    init(json : JSON){
        amIn = json["MORNING_IN"].stringValue
        amOut = json["MORNING_OUT"].stringValue
        pmIn = json["AFTERNOON_IN"].stringValue
        pmOut = json["AFTERNOON_OUT"].stringValue
        date = json["DATE"].stringValue
        isSunday = json["WEEKEND"].bool ?? false
    }
}

class MyAttendanceOverall {
    var shift : Int
    var absent : Int
    var late : Int
    var present : Int
    var myAttendanceDetails = [MyAttendanceDetail]()
    init(json : JSON){
        self.shift = json["shift"].intValue
        self.absent = json["absent"].intValue
        self.late = json["late"].intValue
        self.present = json["present"].intValue
    }
}

class AttendanceReportDetail {
    var name : String
    var second : String
    
    init(json : JSON){
        self.name = json["name"].stringValue
        self.second = (json["sec"].doubleValue).asString(style: .abbreviated)
    }
}

extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    guard let formattedString = formatter.string(from: self) else { return "" }
    return formattedString
  }
}

struct AttendanceRemainPermission {
    var id : Int
    var nameEn : String
    var nameKh : String
    var annualCount : Double
    var employeeLeave : Double
    var remainAmount : Double
    init(json: JSON) {
        self.id = json["id"].intValue
        self.nameEn = json["name"].stringValue
        self.nameKh = json["name_kh"].stringValue
        self.annualCount = json["annual_count"].doubleValue
        self.employeeLeave = json["employee_leave"].doubleValue
        self.remainAmount = self.annualCount - self.employeeLeave
    }
}

struct AttendanceUser {
    var id : String
    var name : String
    
    init(json : JSON){
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
    }
}
