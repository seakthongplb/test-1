//
//  APIManager.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    static let MAIN_URL_2 = "http://103.101.80.73"
//    http://103.101.80.73/figerprint/api_dev/fingerprint_present.php

    //    MARK: - API For Dev
//    static let MAIN_URL = "https://www.turbotech.com/api" // "103.101.80.74"
//    static let MAIN_ATT_URL = MAIN_URL_2 + "/figerprint/api_dev"
//    static let MAINAPP_URL = "http://172.17.168.27:82/api" // mainapp dev
//    static let MAINAPP_URL = "http://172.22.12.125:8000/api" // localhost
//    static let MAINAPP_URL = "http://192.168.43.177:8000/api"

    //    MARK: - API For UAT
    static let MAIN_URL = "https://www.turbotech.com/apiUAT" // "103.101.80.74"
    static let MAIN_ATT_URL = MAIN_URL_2 + "/figerprint/api_mainapp"
    static let MAINAPP_URL = "https://system.turbotech.com/api"
    
    
    static let MAIN_URL_NO_API = "https://www.turbotech.com"
    static let IMAGE_MAIN = MAIN_URL_NO_API + "/storages/assets/img"
    static let IMAGE_URL = "\(IMAGE_MAIN)/img_mobile/"
    static let IMAGE_WEB_URL = "\(IMAGE_MAIN)/services/"
    static let IMAGE_PRO = "\(IMAGE_MAIN)/usermobile/"
    static let IMAGE_EN = "\(IMAGE_MAIN)/sliders/EN/"
    static let IMAGE_KH = "\(IMAGE_MAIN)/sliders/Khmer/"
    static let DEVICE_IMAGE = "http://bscdev.turbotechad.local/storages/assets/img/products/"
    static let HEADER : HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
//    MARK: - E Request
    enum E_Request {
        static let GET_E_REQUEST_FORM = MAINAPP_URL + "/e_request/get_e_request_form"
        static let GET_OWN_REQUEST = MAINAPP_URL + "/e_request/get_all_own_request"
        static let GET_APPROVE_REQUEST = MAINAPP_URL + "/e_request/get_all_approve_request"
        static let GET_KIND_OF_LEAVE = MAINAPP_URL + "/e_request/kind_of_leave"
        static let GET_ = MAINAPP_URL + "/e_request/get_e_request_form"
        static let GET_USER = MAINAPP_URL + "/e_request/get_user"
        static let POST_LEAVE_APPLICATION = MAINAPP_URL + "/e_request/form_leave"
        static let POST_E_REQUEST_DETAIL = MAINAPP_URL + "/e_request/e_request_detail"
        static let GET_ALL_REQUESTS = MAINAPP_URL + "/e_request/get_all_request"
    }
    
    // MARK: - Software Solution
    enum SW_SOLUTION {
        static let GET = MAIN_URL + "/software_solution/"
    }
    
    // MARK: - Sale
    enum SALE {
        static let GET_POP = MAIN_URL + "/sale/POP"
        static let GET_POP_DETAIL = MAIN_URL + "/sale/POP/pop_product.php?popid="
        static let GET_DEVICE = MAIN_URL + "/sale/productlist/"
//        http://bscdev.turbotechad.local/storages/assets/img/products/15949497891355968.jpg
    }
    
    // MARK: - Login
    enum LOGIN {
        static let POST = MAIN_URL + "/login/index.php"
        static let POST_PW = MAIN_URL + "/login/change_pass.php"
        static let GET_USER_CRM = MAIN_URL + "/login/user_crm.php"
    }
    
    // MARK: - Help Desk
    enum HELP_DESK {
        static let POST = MAIN_URL + "/help_dest/addproblem.php"
        static let GET_PROBLEM = MAIN_URL + "/help_dest/readproblemtype.php"
        static let GET = MAIN_URL + "/support/"
    }
    
    // MARK: - Package
    enum PACKAGE {
        static let GET = MAIN_URL + "/package/"
        static let GET_DETAIL = MAIN_URL + "/package_detail"
        static let GET_SOFTWARE_SOLUTIOLN = MAIN_URL + "/software_solution/"
        static let POST_REGISTER_NEW_PACKAGE_BY_USER = MAIN_URL + "/register_service/insert.php"
    }
    
    // MARK: - Product
    enum PRODUCT {
        static let GET = MAIN_URL + "/service"
    }
    
    // MARK: - Attendance
    enum ATTENDANCE {
        static let GET_PRESENT = MAIN_ATT_URL + "/fingerprint_present.php?today_date="
        static let GET_ABSENT = MAIN_ATT_URL + "/fingerprint_absent.php?today_date="
        static let GET_REPORT_EARLY = MAIN_ATT_URL + "/fingerprint_report_early.php"
        static let GET_REPORT_LATE = MAIN_ATT_URL + "/fingerprint_report_late.php"
        static let GET_REPORT_USER_WEEKLY = MAIN_ATT_URL + "/fingerprint_user_weekly.php"
        static let GET_REPORT_USER_MONTHLY = MAIN_ATT_URL + "/"
        static let GET_REPORT_MONTHLY = MAIN_ATT_URL + "/fingerprint_report.php"
        static let GET_REPORT_START_END = MAIN_ATT_URL + "/fingerprint_report_range.php"
        static let POST_LATE_EXCEPTION = MAIN_ATT_URL + "/fingerprint_late_exception.php"
        static let POST_MISSION = MAIN_ATT_URL + "/fingerprint_add_mission.php"
        static let POST_PERMISSION = MAIN_ATT_URL + "/fingerprint_add_permission.php"
        static let GET_REMAIN_PERMISSION = "https://system.turbotech.com" + "/api/hrms_leave_types"
        static let GET_PERMISSION_APPROVER = "https://system.turbotech.com" + "/api/hrms_approve_attendance"
    }
    
    // MARK: - Address
    enum ADDRESS {
        static let PROVINCE = MAIN_URL + "/key_gazetteers/province.php"
        static let DISTRICT = MAIN_URL + "/key_gazetteers/district.php?province_id="
        static let COMMUNE = MAIN_URL + "/key_gazetteers/commune.php?district_id="
        static let VILLAGE = MAIN_URL + "/key_gazetteers/village.php?commune_id="
    }
    
    // MARK: - CRM
    enum CRM {
        static let POST_REGISTER_PACKAGE = MAIN_URL_2 + "/api/register_service/register_crm.php"
        static let POST_CREATE_LEAD = MAIN_URL + "/lead/add_lead.php"
        static let POST_CONVERT_LEAD = MAIN_URL + "/lead/convert_lead.php"
        static let GET_LEAD_ALL = MAIN_URL + "/lead/"
        static let GET_LEAD_BY_ID = MAIN_URL + "/lead/get_lead.php"
        static let GET_PACKAGE = MAIN_URL + "/register_service/readpackage.php"
        static let POST_CREATE_LEAD_SHORT = MAIN_URL + "/lead/addlead_short.php"
        static let GET_STATUS = MAIN_URL + "/lead/lead_status.php"
        static let GET_VAT_TYPE = MAIN_URL + "/lead/lead_vat_type.php"
        static let GET_CUSTOMER_TYPE = MAIN_URL + "/lead/lead_custo_type.php"
        static let GET_CUSTOMER_RATE = MAIN_URL + "/lead/lead_custo_rating_type.php"
        static let GET_INDUSTRY = MAIN_URL + "/lead/lead_industry.php"
        static let GET_ASSIGNED_TO = MAIN_URL + "/lead/lead_assig_to.php"
        static let GET_LEAD_SOURCE = MAIN_URL + "/lead/lead_source.php"
        static let GET_BRANCH = MAIN_URL + "/lead/lead_custo_type.php"
        static let UPDATE_STATUS = MAIN_URL + "/lead/edit_status.php"
        static let UPDATE_FULL_LEAD = MAIN_URL + "/lead/edit_lead.php"
        static let POST_LEAD_TO_DO = MAIN_URL + "/lead/lead_todo.php"
    }
    
    // MARK: - Home
    enum HOME {
        static let GET_IMAGE = MAIN_URL + "/sliders/"
    }
    
    // MARK: - Ticket
    enum TICKET {
        static let GET_TICKET = MAIN_URL + "/tickets/"
        static let GET_SEVERITY =  MAIN_URL + "/tickets/ticket_severity.php"
        static let GET_STATUS =  MAIN_URL + "/tickets/ticket_status.php"
        static let GET_CATEGORY =  MAIN_URL + "/tickets/ticket_category.php"
        static let GET_PRODUCT =  MAIN_URL + "/tickets/ticket_product.php"
        static let GET_CONTACT =  MAIN_URL + "/tickets/ticket_contact.php"
        static let GET_ORGANIZATION = MAIN_URL + "/tickets/ticket_organization.php"
        static let GET_USER = MAIN_URL + "/tickets/user.php"
        static let GET_TICKET_CHART = MAIN_URL + "/tickets/ticket_chart.php"
        static let GET_TICKET_BY_DEPT = MAIN_URL + "/tickets/ticket_by_dapertment.php"
        static let GET_USER_BY_DEPT = MAIN_URL + "/tickets/assing_to_ticket.php"
        static let GET_TICKET_HISTORY = MAIN_URL + "/tickets/get_ticket.php"
        static let POST_EDIT_TICKET = MAIN_URL + "/tickets/edit_ticket.php"
        static let POST_EDIT_TICKET_STATUS = MAIN_URL + "/tickets/edit_ticket_status.php"
        static let POST_NEW_TICKET = MAIN_URL + "/tickets/add_ticket.php"
        static let POST_NEW_TICKET_HELP_DESK = MAIN_URL + "/tickets/add_ticket_byHD.php"
        static let GET_TICKET_IMAGE_URL = MAIN_URL + "/tickets/image_ass.php"
    }
}

