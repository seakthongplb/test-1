//
//  AttandanceViewModel.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

class AttandanceViewModel {
    
    let attandanceService = AttandanceService()
    
    func fetchAttendance(today : String, _ completion : @escaping(_ attendancePresentlist : [String : [AttendancePresent]], _ attendanceAbsentlist : [String : [AttendanceAbsence]], _ report : [String : Int])->Void){
        self.attandanceService.fetchPresent(today: today) { (presentResult) in
            self.attandanceService.fetchAbsent(today: today) { (absentResult) in
//                print("Working at Viewmodel -> REPORT")
                completion(presentResult, absentResult, self.getReport(presentResult, absentResult))
            }
        }
    }
    
    func postMission(mission : Mission, _ completion : @escaping(_ status : Bool)->()){
        self.attandanceService.postMission(mission: mission) { (status) in
            completion(status)
        }
    }
    
    func postPermission(permission : Permission, _ completion : @escaping(_ status : Bool)->()){
        self.attandanceService.postPermission(permission: permission) { (status) in
            completion(status)
        }
    }
    
    func postException(exception : LateException, _ completion : @escaping(_ status : Bool)->()){
        self.attandanceService.postException(exception: exception) { (status) in
            completion(status)
        }
    }
    
    func getReport(_ attendancePresentlist : [String : [AttendancePresent]], _ attendanceAbsentlist : [String : [AttendanceAbsence]])->[String : Int]{
        let am = ["present morning","early morning","late morning","present afternoon","early afternoon","late afternoon"]
        let pm = ["absent morning","absent afternoon","permission morning","permission afternoon"]
        
        var list = [
            am[0] : 0, am[2] : 0, pm[0] : 0, pm[2] : 0,
            am[3] : 0, am[5] : 0, pm[1] : 0, pm[3] : 0
        ]
        
        list[am[0]] = attendancePresentlist[am[0]]?.count ?? 0
        list[am[2]] = attendancePresentlist[am[2]]?.count ?? 0
        list[pm[0]] = attendanceAbsentlist[pm[0]]?.count ?? 0
        list[pm[2]] = attendanceAbsentlist[pm[2]]?.count ?? 0
        
        list[am[3]] = attendancePresentlist[am[3]]?.count ?? 0
        list[am[5]] = attendancePresentlist[am[5]]?.count ?? 0
        list[pm[1]] = attendanceAbsentlist[pm[1]]?.count ?? 0
        list[pm[3]] = attendanceAbsentlist[pm[3]]?.count ?? 0
        
        print(list)
        return list
    }
    /**
     - Returns: 0 is less than 12; 1 less than 17:30; 2 less than 00:00
     */
    func getTimeValue() -> Int {
        /*
         0 : 0 <= x < 12
         1 : 12 <= x < 5:30
         2 : 5:30 < x < 23:59:59
         */
        let date = Date()
        let calendar = Calendar.current
        let h = calendar.component(.hour, from: date)
        let m = calendar.component(.minute, from: date)
        let n = h * 60 + m
        return n < (12 * 60) ? 0 : (n < ((17 * 60) + 30)) ? 1 : 2
    }
    
    func fetchMyAttendance(uID : String, _ completion : @escaping(_ value : [MyAttendanceDetail])->()){
        self.attandanceService.fetchMyAttendance(uID) { (days, values, overall) in
            completion(self.customizeMyAttendanceData(days, values))
        }
    }
    
    func fetchMyAttendance(uID : String, month : Int, year : Int, _ completion : @escaping(_ value : MyAttendanceOverall)->Void){
        self.attandanceService.fetchMyAttendance(uID, isWeek: false, month, year) { (days, values, overall) in
            overall.myAttendanceDetails = self.customizeMyAttendanceData(days, values)
            completion(overall)
        }
    }
    
    func customizeMyAttendanceData(_ days : [String], _ values : [MyAttendanceDetail])->[MyAttendanceDetail]{
        let d = days.count
        let v = values.count
        let c = d<v ? d : v
        for i in 0..<c {
            values[i].amIn = values[i].amIn == "" ? (i==c-1 ? "-" : "missed".localized) : values[i].amIn
            values[i].amOut = values[i].amOut == "" ? (i==c-1 ? "-" : "missed".localized) : values[i].amOut
            values[i].pmIn = values[i].pmIn == "" ? (i==c-1 ? "-" : "missed".localized) : values[i].pmIn
            values[i].pmOut = values[i].pmOut == "" ? (i==c-1 ? "-" : "missed".localized) : values[i].pmOut
            values[i].dayOfWeek = days[i]
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            if let date = dateFormat.date(from: values[i].date) {
                let stringDateFormatter = DateFormatter()
                stringDateFormatter.dateFormat = "dd"
                values[i].date = stringDateFormatter.string(from: date)
            } else {
                values[i].date = ""
            }
        }
        return values
    }
    
    func fetchAttendanceMonthReport(month : Int, year : Int, _ completion : @escaping(_ early : Double, _ late : Double, _ absent : Double)->()){
        self.attandanceService.fetchAttendanceMonthReport(month: month, year: year) { (early, late, absent) in
            completion(early, late, absent)
        }
    }
    
    func fetchAttendanceMonthlyEarlyReportDetail(month: Int, year : Int, _ completion : @escaping(_ list : [AttendanceReportDetail])->()){
        self.attandanceService.fetchAttendanceMonthlyEarlyReportDetail(month: month, year: year) { (results) in
            completion(results)
        }
    }
    
    func fetchAttendanceMonthlyLateReportDetail(month: Int, year : Int, _ completion : @escaping(_ list : [AttendanceReportDetail])->()){
        self.attandanceService.fetchAttendanceMonthlyLateReportDetail(month: month, year: year) { (results) in
            completion(results)
        }
    }
    
    func fetchAttendanceMonthly(startDate sd : String, endDate ed : String, _ completion : @escaping(_ early : Double, _ late : Double, _ absent : Double)->()){
        self.attandanceService.fetchAttendanceMonthly(startDate: sd, endDate: ed) { (early, late, absent) in
            completion(early, late, absent)
        }
    }
    
    func fetchRemainPermission(userId : Int, _ completion : @escaping(_ data : [AttendanceRemainPermission])->()) {
        self.attandanceService.fetchRemainPermission(userId: userId) { (results) in
            completion(results)
        }
    }
    
    func fetchAttendanceUser(_ completion : @escaping(_ data : [AttendanceUser])->Void) {
        self.attandanceService.fetchAttendanceUser { (data) in
            completion(data)
        }
    }
}

