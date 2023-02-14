//
//  AttandanceService.swift
//  TurboTech
//
//  Created by Sov Sothea on 6/9/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AttandanceService {
    
    func fetchPresent(today : String, _ completion : @escaping(_ attendancePresentlist : [String : [AttendancePresent]])->Void){
        print(APIManager.ATTENDANCE.GET_PRESENT + today)
        AF.request(APIManager.ATTENDANCE.GET_PRESENT + today, method: .get).response{response in
            let name = ["present morning","early morning","late morning","present afternoon","early afternoon","late afternoon"]
            var list = [
                name[0] : [AttendancePresent](),
                name[1] : [AttendancePresent](),
                name[2] : [AttendancePresent](),
                name[3] : [AttendancePresent](),
                name[4] : [AttendancePresent](),
                name[5] : [AttendancePresent]()
            ]
            guard let data = response.data else {
                completion(list)
                return
            }
            if let jsons = try? JSON(data: data) {
                var swapList = [AttendancePresent]()
                name.forEach { (n) in
                    jsons[n].arrayValue.forEach { (json) in
                        swapList.append(AttendancePresent(json: json))
                    }
                    list[n] = swapList
                    swapList.removeAll()
                }
            }
            completion(list)
        }
    }
    
    func fetchAbsent(today : String, _ completion : @escaping(_ attendancePresentlist : [String : [AttendanceAbsence]])->Void){
        print(APIManager.ATTENDANCE.GET_ABSENT + today)
        AF.request(APIManager.ATTENDANCE.GET_ABSENT + today, method: .get).response{response in
            let name = ["absent morning","absent afternoon","permission morning","permission afternoon"]
            var list = [
                name[0] : [AttendanceAbsence](),
                name[1] : [AttendanceAbsence](),
                name[2] : [AttendanceAbsence](),
                name[3] : [AttendanceAbsence]()
            ]
            guard let data = response.data else {
                completion(list)
                return
            }
            if let jsons = try? JSON(data: data) {
                for i in 0...3{
                    jsons[name[i]].arrayValue.forEach { (json) in
                        list[name[i]]?.append(AttendanceAbsence(json: json))
                    }
                }
            }
            completion(list)
        }
    }
    
    func postMission(mission : Mission, _ completion : @escaping(_ status : Bool)->()){
        let parameters = [
            "reason" : mission.reason,
            "shift" : mission.shift, // am or pm or full
            "staff_id_number" : mission.staffIdNumber,
            "type" : mission.type,
            "user_id" : mission.userId, // TT-0001
            "date_from" : mission.fromDate,
            "date_to" : mission.toDate
        ]
        AF.request(APIManager.ATTENDANCE.POST_MISSION, method: .post, parameters: parameters).response { response in
            guard let data = response.data else {
                completion(false)
                return
            }
            if (try? JSON(data: data)) != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func postPermission(permission : Permission, _ completion : @escaping(_ status : Bool)->()){
        
        let array = permission.editorId.components(separatedBy: "-")
        
        let parameters = [
            "user_id" : permission.userId,
            "editor_id" : array[1],
            "approve_by" : permission.approveBy,
            "reason" : permission.reason,
            "date_from" : permission.dateFrom,
            "date_to" : permission.dateTo,
            "leave_type" : "\(permission.leaveType ?? 1)"
        ]
        
        parameters.forEach { (key, value) in
            print(key, value as Any)
        }
        
        AF.request(APIManager.ATTENDANCE.POST_PERMISSION, method: .post, parameters: parameters).response { response in
            guard let data = response.data else {
                print("else return")
                completion(false)
                return
            }
            if (try? JSON(data: data)) != nil {
                print("this is work")
                completion(true)
            } else {
                print("! this is work")
                completion(false)
            }
        }
        
    }
    
    func postException(exception : LateException, _ completion : @escaping(_ status : Bool)->()){
        let array = exception.userId.components(separatedBy: "-")
        let parameters = [
            "is_exception" : exception.isException,
            "description" : exception.description,
            "ma_user_id" : exception.maUserId, // id 1
            "user_id" :  array[1]// id TT-001111
            ] as [String : Any]
        
        parameters.forEach { (key, value) in
            print(key, value)
        }
        
        AF.request(APIManager.ATTENDANCE.POST_LATE_EXCEPTION, method: .post, parameters: parameters).response { response in
            guard let data = response.data else {
                completion(false)
                return
            }
            if (try? JSON(data: data)) != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func fetchMyAttendance(_ uID : String, isWeek : Bool = true, _ month : Int = 1, _ year : Int = 2020, _ completion : @escaping(_ days : [String], _ value : [MyAttendanceDetail], _ overall : MyAttendanceOverall)->()){
        var dayOfWeek : [String] = [String]()
        var values : [MyAttendanceDetail] = [MyAttendanceDetail]()
        var myAttendanceOverall : MyAttendanceOverall!
        AF.request(APIManager.ATTENDANCE.GET_REPORT_USER_MONTHLY+"fingerprint_user_\(isWeek ?  "weekly" : "monthly").php?uid=\(uID)&month=\(month)&year=\(year)", method: .get).response{ response in
            guard let data = response.data else { return }
            if let jsons = try? JSON(data: data) {
                dayOfWeek = jsons["day"].arrayValue.map { $0.stringValue}
                for json in jsons["value"].arrayValue {
                    values.append(MyAttendanceDetail(json: json[0]))
                }
                myAttendanceOverall = MyAttendanceOverall(json: jsons)
            } else {
                return
            }
            completion(dayOfWeek, values, myAttendanceOverall)
        }
    }
    
    func fetchAttendanceMonthReport(month : Int, year : Int, _ completion : @escaping(_ early : Double, _ late : Double, _ absent : Double)->()){
        AF.request(APIManager.ATTENDANCE.GET_REPORT_MONTHLY+"?month=\(month)&year=\(year)", method: .get).response{ response in
            guard let data = response.data else { return }
            if let json = try? JSON(data: data) {
                completion(json["present_early"].doubleValue, json["present_late"].doubleValue, json["absent"].doubleValue)
            }
        }
    }
    
    func fetchAttendanceMonthlyEarlyReportDetail(month: Int, year : Int, _ completion : @escaping(_ list : [AttendanceReportDetail])->()){
        AF.request(APIManager.ATTENDANCE.GET_REPORT_EARLY+"?month=\(month)&year=\(year)",method: .get).response{ response in
            guard let data = response.data else { return }
            var reports = [AttendanceReportDetail]()
            if let jsons = try? JSON(data: data) {
                for json in jsons["result"].arrayValue {
                    let report = AttendanceReportDetail(json: json)
                    reports.append(report)
                }
            }
            completion(reports)
        }
    }
    
    func fetchAttendanceMonthlyLateReportDetail(month: Int, year : Int, _ completion : @escaping(_ list : [AttendanceReportDetail])->()){
        AF.request(APIManager.ATTENDANCE.GET_REPORT_LATE+"?month=\(month)&year=\(year)",method: .get).response{ response in
            guard let data = response.data else { return }
            var reports = [AttendanceReportDetail]()
            if let jsons = try? JSON(data: data) {
                for json in jsons["result"].arrayValue {
                    let report = AttendanceReportDetail(json: json)
                    reports.append(report)
                }
            }
            completion(reports)
        }
    }
    
    func fetchAttendanceMonthly(startDate sd : String, endDate ed : String, _ completion : @escaping(_ early : Double, _ late : Double, _ absent : Double)->()){
        AF.request(APIManager.ATTENDANCE.GET_REPORT_START_END+"?start=\(sd)&end=\(ed)", method: .get).response { response in
            guard let data = response.data else { return }
            if let json = try? JSON(data: data) {
                completion(json["present_early"].doubleValue,json["present_late"].doubleValue,json["absent"].doubleValue)
            }
        }
    }
    
    // MARK: - From System.Turbotech.Com -> HRMS
    func fetchRemainPermission(userId : Int, _ completion : @escaping(_ data : [AttendanceRemainPermission])->()) {
        AF.request(APIManager.ATTENDANCE.GET_REMAIN_PERMISSION + "/\(userId)", method: .get).response {response in
            guard let data = response.data else { return }
            var list = [AttendanceRemainPermission]()
            if let jsons = try? JSON(data: data){
                for json in jsons.arrayValue {
                    list.append(AttendanceRemainPermission(json: json))
                }
            }
            completion(list)
        }
    }
    
    func fetchAttendanceUser(_ completion : @escaping(_ data : [AttendanceUser])->Void) {
        AF.request(APIManager.ATTENDANCE.GET_PERMISSION_APPROVER, method: .get).response{ response in
            var list = [AttendanceUser]()
            guard let data = response.data else {
                completion(list)
                return
            }
            if let jsons = try? JSON(data: data) {
                for json in jsons.arrayValue {
                    list.append(AttendanceUser(json: json))
                }
            }
            completion(list)
        }
    }
}
