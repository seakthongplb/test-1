//
//  CRMFullRegisterViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import LGButton
import FittedSheets

class CRMFullRegisterViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstStepView: CRMRegisterFirstStepView!
    @IBOutlet weak var registerContactInformationView: CRMRegisterContactInformationView!
    @IBOutlet weak var registerAddressInformationView: CRMRegisterAddressInformationView!
    
    var userCheckedInLocationViewController : UserCheckedInLocationViewController!
    var sheetController : SheetViewController!
    
    @IBOutlet weak var fullRegisterProgressBar: FlexibleSteppedProgressBar!
    @IBOutlet weak var nextButton : LGButton!
    @IBOutlet weak var previousButton : LGButton!
    
    // MARK: - Dataset
    lazy var crmViewModel = CRMViewModel()
    lazy var crmCustomerRegistration = CRMCustomerRegistration()
    var crmLeadInformation : CRMLeadInformation?
    var crmContactInformation : CRMContactInformation?
    var crmAddressInformation : CRMAddressInformation?
    var lat : Double?
    var lng : Double?
    var onDoneBlock : ((_ status : Bool)->())?
    var addedStatus : Bool = false
    var lead : LeadDetail?
    var isOldLead : Bool = false
    var leadId : String?
    
    var progressBar: FlexibleSteppedProgressBar!
    var progressBarWithoutLastState: FlexibleSteppedProgressBar!
    var progressBarWithDifferentDimensions: FlexibleSteppedProgressBar!
    
    var backgroundColor = UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    var progressColor = UIColor(red: 53.0 / 255.0, green: 226.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)
    var textColorHere = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    
    var maxIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFullRegisterProgressBar(pb: self.fullRegisterProgressBar)
        setupView()
        if isOldLead {
            if let lead = self.lead {
                setLeadData(lead)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let onDoneBlock = self.onDoneBlock {
            onDoneBlock(addedStatus)
        }
    }
    
    private func setupView(){
        titleLabel.text = "create lead".localized
        self.registerAddressInformationView.shareLocationLgButton.addTarget(self, action: #selector(mapPressed(_:)), for: .touchUpInside)
        previousButton.titleString = "cancel".localized
        nextButton.titleString = "next".localized
    }
    
    public func setLead(_ lead : LeadDetail) {
        self.lead = lead
    }
    
    private func setLeadData(_ lead : LeadDetail){
        crmLeadInformation = CRMLeadInformation(compnayName: lead.companyName, customerName: lead.companyKh, primaryPhone: lead.leadPhone, vatType: lead.vatType, customerType: lead.cusType, customerRate: lead.cusRatingType, industry: lead.industry, assignedTo: lead.assigTo, leadSource: lead.leadSource, branch: lead.branch)
        crmContactInformation = CRMContactInformation(firstName: lead.firstName, lastName: lead.lastName, phoneNumber: lead.contactPhone, contactEmail: lead.contactEmail, position: lead.position)
        crmAddressInformation = CRMAddressInformation(provinceId: lead.province, districtId: lead.district, communeId: lead.commune, villageId: lead.village, homeNumber: lead.home, streetNumber: lead.street, lat: lead.lat, lng: lead.lng)

        firstStepView.crmLeadInformation = crmLeadInformation
        registerContactInformationView.crmContactInformation = crmContactInformation
        registerAddressInformationView.crmAddressInformation = crmAddressInformation
        self.lat = lead.lat
        self.lng = lead.lng
        self.registerAddressInformationView.shareLocationLgButton.titleString = "\(self.lat ?? 0),\(self.lng ?? 0)"
    }
    
//    MARK: - Previous Pressed
    @IBAction func previousTouched(_ sender : Any) {
        
        if previousButton.titleString == "cancel".localized {
            self.dismiss(animated: true, completion: nil)
        } else {
            progressBar(fullRegisterProgressBar,
            didSelectItemAtIndex : fullRegisterProgressBar.currentIndex - 1)
        }
        
        let index = fullRegisterProgressBar.currentIndex
        moveBack(index)
    }
    
    func moveBack(_ moveTo : Int){
        switch moveTo {
        case 0 :
            firstStepView.isHidden = false
            registerContactInformationView.isHidden = true
        case 1:
            registerContactInformationView.isHidden = false
        default: return
        }
    }
    
//    MARK: - Next Pressed
    @IBAction func nextTouched(_ sender : Any) {
        let index = fullRegisterProgressBar.currentIndex
        if !moveForward(index) {
            return
        }
        
        if nextButton.titleString == "save".localized {
        } else {
            progressBar(fullRegisterProgressBar, didSelectItemAtIndex : fullRegisterProgressBar.currentIndex + 1)
        }
    }
    
    func moveForward(_ currentIndex : Int) -> Bool {
        switch currentIndex {
            case 0 :
                crmLeadInformation = firstStepView.isValidData()
                if crmLeadInformation == nil {
                    return false
                } else {
                    crmCustomerRegistration.crmLeadInformation = crmLeadInformation
                    firstStepView.isHidden = true
                    registerContactInformationView.isHidden = false
                }
            case 1:
                crmContactInformation = registerContactInformationView.isValidData()
                if crmContactInformation == nil {
                    return false
                } else {
                    crmCustomerRegistration.crmContactInformation = crmContactInformation
                    registerContactInformationView.isHidden = true
                    registerAddressInformationView.isHidden = false
                }
            case 2:
//                print("Work case 2")
                crmAddressInformation = registerAddressInformationView.isValidData()
                if crmAddressInformation == nil {
                    self.progressBar(fullRegisterProgressBar, didSelectItemAtIndex: 2)
                    return false
                } else {
                    if isOldLead {
                        crmCustomerRegistration.crmAddressInformation = crmAddressInformation
                        postCreateLead()
                    } else {
                        if lat == nil || lng == nil && isOldLead{
                            registerAddressInformationView.shareLocationLgButton.titleColor = .red
                        } else {
                            let oldAddress = crmAddressInformation
                            crmAddressInformation = CRMAddressInformation(provinceId: oldAddress?.provinceId, districtId: oldAddress?.districtId, communeId: oldAddress?.communeId, villageId: oldAddress?.villageId, homeNumber: oldAddress?.homeNumber, streetNumber: oldAddress?.streetNumber, lat: lat, lng: lng)
                            crmCustomerRegistration.crmAddressInformation = crmAddressInformation
                            postCreateLead()
                        }
                    }
                }
            default :
                return false
            }
        return true
    }
    
//    MARK: - Create Lead
    func postCreateLead(){
        DispatchQueue.main.async {
            if let username = AppDelegate.user?.userName {
                self.crmViewModel.postCreateNewLead(username: username, leadId: self.isOldLead ? self.leadId : nil, crmCustomerRegistration: self.crmCustomerRegistration) { (message, lead) in
                    self.showAndDismissAlert(title: message, message: message, style: .alert, second: 1.5)
                    self.dismiss(animated: false){
                        self.addedStatus = true
                    }
                }
            } else {
                self.showAndDismissAlert(title: "no username".localized, message: nil, style: .alert, second: 1.0)
            }
        }
    }
}

// MARK: - FlexibleSteppedProgressBarDelegate
extension CRMFullRegisterViewController : FlexibleSteppedProgressBarDelegate {
    
    func setupFullRegisterProgressBar(pb : FlexibleSteppedProgressBar){
        pb.numberOfPoints = 3
        pb.lineHeight = 3
        pb.radius = 20
        pb.progressRadius = 25
        pb.progressLineHeight = 3
        pb.delegate = self
        pb.selectedBackgoundColor = .blue //progressColor
        pb.selectedOuterCircleStrokeColor = .blue //backgroundColor
        pb.currentSelectedCenterColor = .white //progressColor
        pb.stepTextColor = .lightGray //textColorHere
        pb.currentSelectedTextColor = .darkGray //progressColor
        pb.currentIndex = 0
        
        firstStepView.isHidden = false
        registerContactInformationView.isHidden = true
        registerAddressInformationView.isHidden = true
        previousButton.titleString = "cancel".localized
        previousButton.leftImageSrc = nil
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, didSelectItemAtIndex index: Int) {
        progressBar.currentIndex = index
        
        if index > maxIndex {
            maxIndex = index
            progressBar.completedTillIndex = maxIndex
        }
        
        if index == 0 {
            previousButton.titleString = "cancel".localized
            previousButton.leftImageSrc = nil
        } else {
            previousButton.titleString = "previous".localized
            previousButton.leftImageSrc = UIImage(named: "back")
            previousButton.isHidden = false
        }

        if index == progressBar.numberOfPoints - 1 {
            nextButton.titleString = "save".localized
            nextButton.rightImageSrc = nil
        } else {
            nextButton.titleString = "next".localized
            nextButton.rightImageSrc = UIImage(named: "next")
            nextButton.isHidden = false
        }
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, canSelectItemAtIndex index: Int) -> Bool {
        let currentIndex = progressBar.currentIndex
        if currentIndex + 2 == index {
//            crmLeadInformation = firstStepView.isValidData()
//            crmContactInformation = registerContactInformationView.isValidData()
//            if crmLeadInformation != nil && crmContactInformation != nil {
//                return moveForward(currentIndex)
//            }
            return false
        }
        if index < currentIndex {
            moveBack(index)
            return true
        }
        return moveForward(currentIndex)
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if position == FlexibleSteppedProgressBarTextLocation.bottom {
            switch index {
                case 0:
                    return "lead".localized
                case 1:
                    return "contact".localized
                case 2:
                    return "address".localized
                default:
                    return "Def"
            }
        }
        return ""
    }
}

// MARK: - For CRMRegisterAddressInformationView
extension CRMFullRegisterViewController {
    @objc
    func mapPressed(_ sender : Any) {
        let deptStoryboard = UIStoryboard(name: "DepartmentStoryboard", bundle: nil)
        userCheckedInLocationViewController = (deptStoryboard.instantiateViewController(withIdentifier: "UserCheckedInLocationViewControllerID") as! UserCheckedInLocationViewController)
        
        if let lead = self.lead {
            userCheckedInLocationViewController.lat = lead.lat
            userCheckedInLocationViewController.lng = lead.lng
        }
        userCheckedInLocationViewController.onDismissHandle = {(lat , lng) in
            self.lat = (round(lat*1000000))/1000000
            self.lng = (round(lng*1000000))/1000000
            self.registerAddressInformationView.shareLocationLgButton.titleString = "\(self.lat ?? 0),\(self.lng ?? 0)"
        }
        sheetController = SheetViewController(controller: userCheckedInLocationViewController, sizes: [.percent(0.5), .percent(0.75)])
        sheetController.dismiss(animated: true) {
            
        }
        
        
        self.present(sheetController, animated: false, completion: nil)
    }
    
}
