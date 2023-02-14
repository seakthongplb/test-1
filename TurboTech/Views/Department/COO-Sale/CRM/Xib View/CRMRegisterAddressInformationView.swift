//
//  CRMRegisterAddressInformationView.swift
//  TurboTech
//
//  Created by sq on 6/30/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import LGButton

class CRMRegisterAddressInformationView: UIView {
    
    let lang = LanguageManager.shared.language
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var homeNumberTextField : UITextField!
    @IBOutlet var streetNumberTextField : UITextField!
    @IBOutlet var provinceTextField : UITextField!
    @IBOutlet var districtTextField : UITextField!
    @IBOutlet var communeTextField : UITextField!
    @IBOutlet var villageTextField : UITextField!
    @IBOutlet weak var shareLocationLgButton: LGButton!
    
    private var addressList = [Address]()
    private var provinceList = [Address]()
    private var districtList = [Address]()
    private var communeList = [Address]()
    private var villageList = [Address]()
    
    private var proId : Int?
    private var disId : Int?
    private var comId : Int?
    private var vilId : Int?
    
    private let picker = UIPickerView()
    private var activeTextField = UITextField()
    var crmViewModel = CRMViewModel()
    var saleViewModel = SaleViewModel()
    var crmAddressInformation : CRMAddressInformation?
    
    override init(frame: CGRect) {
//        Using CustomView in Code
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        Using customView in IB
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CRMRegisterAddressInformationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setup()
        fetchOldData()
    }
    
    private func setup(){
        localized()
        self.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        homeNumberTextField.customizeRegister()
        streetNumberTextField.customizeRegister()
        provinceTextField.customizeRegister()
        districtTextField.customizeRegister()
        communeTextField.customizeRegister()
        villageTextField.customizeRegister()
        
        provinceTextField.setDropDownImage()
        districtTextField.setDropDownImage()
        communeTextField.setDropDownImage()
        villageTextField.setDropDownImage()
        
        provinceTextField.inputView = picker
        districtTextField.inputView = picker
        communeTextField.inputView = picker
        villageTextField.inputView = picker
        
        picker.dataSource = self
        picker.delegate = self
        
        homeNumberTextField.delegate = self
        streetNumberTextField.delegate = self
        provinceTextField.delegate = self
        districtTextField.delegate = self
        communeTextField.delegate = self
        villageTextField.delegate = self
        fetchOldData()
    }
    
    func localized(){
        titleLabel.text = "address information".localized
        shareLocationLgButton.titleString = "choose location".localized
    }
    
    func setData(type : ADDRESS, id : String){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = COLOR.RED
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "done".localized, style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        activeTextField.inputView = picker
        activeTextField.inputAccessoryView = toolBar
        
        DispatchQueue.main.async {
//            print("WORK")
            self.saleViewModel.fetchAddress(addressType: type, id: id) { (list) in
//                print("cur id : ", id, type)
                self.addressList = list
                var pickID : Int = 0
                switch type {
                    case .province :
                        self.provinceList = list
                        if let id = self.proId {
                            pickID = id
                        }
                    case .district :
                        self.districtList = list
                        if let id = self.disId {
                            pickID = id
                        }
                    case .commune :
                        self.communeList = list
                        if let id = self.comId {
                            pickID = id
                        }
                    case .village :
                        self.villageList = list
                        if let id = self.vilId {
                            pickID = id
                        }
                }
                self.picker.reloadAllComponents()
                self.picker.selectRow(pickID, inComponent: 0, animated: true)
                self.pickerView(self.picker, didSelectRow: pickID, inComponent: 0)
            }
        }
    }
    
    func fetchOldData(){
        DispatchQueue.main.async {
            if let data = self.crmAddressInformation {
                self.homeNumberTextField.text = data.homeNumber
                self.streetNumberTextField.text = data.streetNumber
                self.saleViewModel.fetchAddress(addressType: .province, id: "") { (list) in
                    self.provinceList = list
                    if let id = list.firstIndex(where: {$0.nameEn == data.provinceId}) {
                        self.proId = id
                        self.districtTextField.isEnabled = true
                        self.provinceTextField.text = self.lang == "en" ? list[id].nameEn : list[id].nameKh
                        self.saleViewModel.fetchAddress(addressType: .district, id: list[id].gazcode) { (list) in
                            self.districtList = list
                            if let id = list.firstIndex(where: {$0.nameEn == data.districtId}) {
                                self.disId = id
                                self.communeTextField.isEnabled = true
                                self.districtTextField.text = self.lang == "en" ? list[id].nameEn : list[id].nameKh
                                self.saleViewModel.fetchAddress(addressType: .commune, id: list[id].gazcode) { (list) in
                                    self.communeList = list
                                    if let id = list.firstIndex(where: {$0.nameEn == data.communeId}) {
                                        self.comId = id
                                        self.villageTextField.isEnabled = true
                                        self.communeTextField.text = self.lang == "en" ? list[id].nameEn : list[id].nameKh
                                        self.saleViewModel.fetchAddress(addressType: .village, id: list[id].gazcode) { (list) in
                                            self.villageList = list
                                            if let id = list.firstIndex(where: {$0.nameEn == data.villageId}) {
                                                self.vilId = id
                                                self.villageTextField.text = self.lang == "en" ? list[id].nameEn : list[id].nameKh
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func shareLocationLgPressed(_ sender: Any) {
//        isShared = !isShared
//        if isShared {
//            shareLocationLgButton.leftImageSrc = checked
//            locationManager.requestWhenInUseAuthorization()
//            var currentLoc: CLLocation!
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//            if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == .authorizedAlways) {
//               currentLoc = locationManager.location
//               print(currentLoc.coordinate.latitude)
//               print(currentLoc.coordinate.longitude)
//            }
//        } else {
//            shareLocationLgButton.leftImageSrc = square
//        }
    
    }
}

extension CRMRegisterAddressInformationView : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if self.provinceTextField.isEditing {
                setData(type: .province, id: "")
        } else if self.districtTextField.isEditing {
            guard let id = proId else {
                return
            }
            setData(type: .district, id: provinceList[id].gazcode)
        } else if self.communeTextField.isEditing {
            guard let id = disId else {
                return
            }
            setData(type: .commune, id: districtList[id].gazcode)
        } else if self.villageTextField.isEditing {
            guard let id = comId else {
                return
            }
            setData(type: .village, id: communeList[id].gazcode)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case provinceTextField, districtTextField, communeTextField, villageTextField :
            return false
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 10
        if let nextResponder = textField.superview?.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension CRMRegisterAddressInformationView : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addressList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lang == "en" ? addressList[row].nameEn : addressList[row].nameKh
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeTextField.text = lang == "en" ? addressList[row].nameEn : addressList[row].nameKh
//        print("SELECTED ROW : ", row)
        if activeTextField == provinceTextField && row != proId {
            districtTextField.isEnabled = true
            communeTextField.isEnabled = false
            villageTextField.isEnabled = false
            proId = row
            
            self.districtTextField.text = nil
            self.disId = nil
            self.communeTextField.text = nil
            self.comId = nil
            self.villageTextField.text = nil
            self.vilId = nil
        } else if activeTextField == districtTextField && row != disId{
            communeTextField.isEnabled = true
            villageTextField.isEnabled = false
            disId = row
            self.communeTextField.text = nil
            self.comId = nil
            self.villageTextField.text = nil
            self.vilId = nil
        } else if activeTextField == communeTextField && row != comId{
            villageTextField.isEnabled = true
            comId = row
            self.villageTextField.text = nil
            self.vilId = nil
        } else if activeTextField == villageTextField && row != vilId{
            vilId = row
        }
    }
    
}

extension CRMRegisterAddressInformationView {
    
    @objc func donePicker(_ sender : UIBarButtonItem){
        activeTextField.resignFirstResponder()
    }
    
    func addDoneButtonOnKeyboard() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = COLOR.BLUE
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        provinceTextField.inputAccessoryView = toolBar
        districtTextField.inputAccessoryView = toolBar
        communeTextField.inputAccessoryView = toolBar
        villageTextField.inputAccessoryView = toolBar
        homeNumberTextField.inputAccessoryView = toolBar
        streetNumberTextField.inputAccessoryView = toolBar
        
        provinceTextField.autocorrectionType = .no
        districtTextField.autocorrectionType = .no
        communeTextField.autocorrectionType = .no
        villageTextField.autocorrectionType = .no
        homeNumberTextField.autocorrectionType = .no
        streetNumberTextField.autocorrectionType = .no

    }
    
    func doneButtonAction() {
        provinceTextField.resignFirstResponder()
        districtTextField.resignFirstResponder()
        communeTextField.resignFirstResponder()
        villageTextField.resignFirstResponder()
        homeNumberTextField.resignFirstResponder()
        streetNumberTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset : UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardSize.size.height + 16
            scrollView.contentInset = contentInset
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func setValidLocationButton(){
        shareLocationLgButton.titleColor = .white
    }
    
    func setUnvalidLocationButton(){
        shareLocationLgButton.titleColor = .red
    }
    
    func isValidData() -> (CRMAddressInformation?){
        var red = UIColor.red.cgColor
        if crmAddressInformation != nil {
            red = UIColor.gray.cgColor
        }
        let gray = UIColor.gray.cgColor
        
        provinceTextField.layer.borderColor = gray
        districtTextField.layer.borderColor = gray
        communeTextField.layer.borderColor = gray
        villageTextField.layer.borderColor = gray
        homeNumberTextField.layer.borderColor = gray
        streetNumberTextField.layer.borderColor = gray
        shareLocationLgButton.titleColor = .gray
        guard let pId = proId, let dId = disId, let cId = comId, let homeNumber = homeNumberTextField.text, let streetNumber = streetNumberTextField.text else {
        
            if proId == nil {
                provinceTextField.layer.borderColor = red
            }
            
            if disId == nil {
                districtTextField.layer.borderColor = red
            }
            
            if comId == nil {
                communeTextField.layer.borderColor = red
            }
            
            if vilId == nil {
                villageTextField.layer.borderColor = red
            }
            
            if homeNumberTextField.text == "" {
                homeNumberTextField.layer.borderColor = red
            }
            
            if streetNumberTextField.text == "" {
                streetNumberTextField.layer.borderColor = red
            }
            return nil
        }
        
        var isValidVillage = false
        var postVilId : String = ""
        
        if let _ = proId {
            if let _ = disId {
                if let _ = comId {
                    if let vId = vilId {
                        postVilId = villageList[vId].gazcode
                        isValidVillage = true
                    } else {
                        villageTextField.layer.borderColor = red
                    }
                } else {
                    communeTextField.layer.borderColor = red
                    villageTextField.layer.borderColor = red
                }
            }
            else {
                districtTextField.layer.borderColor = red
                communeTextField.layer.borderColor = red
                villageTextField.layer.borderColor = red
            }
        } else {
            provinceTextField.layer.borderColor = red
            districtTextField.layer.borderColor = red
            communeTextField.layer.borderColor = red
            villageTextField.layer.borderColor = red
        }
        
        if !isValidVillage {
            postVilId = "01010101"
        }
        
        return CRMAddressInformation(provinceId: provinceList[pId].nameEn, districtId: districtList[dId].nameEn, communeId: communeList[cId].nameEn, villageId: postVilId, homeNumber: homeNumber, streetNumber: streetNumber)
        
    }
}

