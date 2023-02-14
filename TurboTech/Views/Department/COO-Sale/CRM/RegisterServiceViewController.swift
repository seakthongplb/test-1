//
//  RegisterServiceViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import iOSDropDown
import CoreLocation
import Kingfisher
import LGButton

class RegisterServiceViewController: UIViewController {
    
    let lang = LanguageManager.shared.language
    
    // MARK: - View Model
    lazy var crmViewModel = CRMViewModel()
    lazy var saleViewModel = SaleViewModel()
    lazy var locationManager = CLLocationManager()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    // MARK: - inputStyle -> PickerView
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var communeTextField: UITextField!
    @IBOutlet weak var villageTextField: UITextField!
    @IBOutlet weak var homeStreetTextField: UITextField!
    
    // MARK: - Button
    @IBOutlet weak var chooseProductLgButton: LGButton!
    @IBOutlet weak var shareLocationLgButton: LGButton!
    @IBOutlet weak var registerButton: UIButton!
    private var isShared = false
    private var isMale = true
    private var packageId : Int?
    private var packageName : String?
    
    // MARK: - Storing each address
    private var packageList = [CRMPackage]()
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
    
    private let square = UIImage(named: "square")
    private let checked = UIImage(named: "check-square")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        fetchData()
    }
    
    private func setView(){
        
        self.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        firstNameTextField.customizeRegister()
        lastNameTextField.customizeRegister()
        phoneNumberTextField.customizeRegister()
        provinceTextField.customizeRegister()
        provinceTextField.setDropDownImage()
        communeTextField.customizeRegister()
        communeTextField.setDropDownImage()
        districtTextField.customizeRegister()
        districtTextField.setDropDownImage()
        villageTextField.customizeRegister()
        villageTextField.setDropDownImage()
        homeStreetTextField.customizeRegister()
        chooseProductLgButton.titleString = "choose our internet package".localized
        
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        registerButton.setTitle("register".localized, for: .normal)
        
        shareLocationLgButton.titleString = "share location".localized
        shareLocationLgButton.leftImageSrc = square
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        homeStreetTextField.delegate = self
        
        
        activeTextField.delegate = self
        
        provinceTextField.delegate = self
        districtTextField.delegate = self
        communeTextField.delegate = self
        villageTextField.delegate = self
        
        picker.dataSource = self
        picker.delegate = self
    }
    
    @objc func donePicker(_ sender : UIBarButtonItem){
        activeTextField.resignFirstResponder()
    }
    
    
    @IBAction func shareLocationLgPressed(_ sender: Any) {
        isShared = !isShared
        if isShared {
            shareLocationLgButton.leftImageSrc = checked
            locationManager.requestWhenInUseAuthorization()
//            var currentLoc: CLLocation!
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
//               currentLoc = locationManager.location
            }
        } else {
            shareLocationLgButton.leftImageSrc = square
        }
    }
    
    @IBAction func choosePackageLgPressed(_ sender: Any) {
        let choosePackageVC = storyboard?.instantiateViewController(withIdentifier: "PackageCRMViewControllerID") as! PackageCRMViewController
        choosePackageVC.modalPresentationStyle = .overCurrentContext
        if let selected = packageId {
            choosePackageVC.oldSelected = selected
        }
        choosePackageVC.popUpSearchList = self.packageList
        choosePackageVC.onDoneBlock = { id, name in
            self.packageId = id
            self.packageName = name
            self.chooseProductLgButton.titleString = name
        }
        self.present(choosePackageVC, animated: true, completion: nil)
    }
    
    @IBAction func registerPress(_ sender: Any) {
        guard let fname = firstNameTextField.text, let lname = lastNameTextField.text, let phone = phoneNumberTextField.text else { return }
        
        let gray = UIColor.gray.cgColor
        let red = UIColor.red.cgColor
        
        firstNameTextField.layer.borderColor = gray
        lastNameTextField.layer.borderColor = gray
        phoneNumberTextField.layer.borderColor = gray
        provinceTextField.layer.borderColor = gray
        districtTextField.layer.borderColor = gray
        communeTextField.layer.borderColor = gray
        villageTextField.layer.borderColor = gray
        chooseProductLgButton.titleColor = .white
        chooseProductLgButton.titleColor = .white
        chooseProductLgButton.backgroundColor = .systemTeal
        chooseProductLgButton.borderColor = .white
        
        let isValidateFirstName = Validaton.shared.validationName(name: fname)
        if !isValidateFirstName {
            firstNameTextField.layer.borderColor = red
        }
        
        let isValidateLastName = Validaton.shared.validationName(name: lname)
        if !isValidateLastName {
            lastNameTextField.layer.borderColor = red
        }
        
        let isValidationPhone = Validaton.shared.validaPhoneNumber(phoneNumber: phone)
        if !isValidationPhone {
            phoneNumberTextField.layer.borderColor = red
        }
//        var isValidVillage = false
        var postVilId : String = ""
        if let _ = proId {
            if let _ = disId {
                if let _ = comId {
                    if let vId = vilId {
                        postVilId = villageList[vId].gazcode
//                        isValidVillage = true
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
        
        if packageId == nil {
            chooseProductLgButton.titleColor = .red
            chooseProductLgButton.bgColor = .white
            chooseProductLgButton.borderColor = .red
            chooseProductLgButton.borderWidth = 1.0
            chooseProductLgButton.titleColor = .red
        }
        
        // MARK: - Everything can post request URL
        if isValidateFirstName && isValidateLastName{
            let register = RegisterPackageCRM(fname: fname, lname: lname, email: "", phone: phone, latlong: nil, homeNStreetN: nil, packageId: "\(packageId ?? 0)", villageId: postVilId, userName: "monyoudom.bun")
            DispatchQueue.main.async {
                self.crmViewModel.postRegisterPackageCRM(registerPackageCRM: register) { (code, message) in
                    self.showAndDismissAlert(title: message, message: nil, style: .alert, second: 3)
                    if code == 200 {
                        self.clearDataWhenDone()
                    }
                }
            }
        }
    }
    
    private func clearDataWhenDone(){
        firstNameTextField.text = nil
        lastNameTextField.text = nil
        phoneNumberTextField.text = nil
        provinceTextField.text = nil
        districtTextField.text = nil
        communeTextField.text = nil
        villageTextField.text = nil
        homeStreetTextField.text = nil
        chooseProductLgButton.titleString = "choose our internet package".localized
        isShared = false
        isMale = true
        packageId = nil
        packageName = nil
        proId = nil
        disId = nil
        comId = nil
        vilId = nil
    }
    
}

extension RegisterServiceViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        addressList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lang == "en" ? addressList[row].nameEn : addressList[row].nameKh
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeTextField.text = lang == "en" ? addressList[row].nameEn : addressList[row].nameKh
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

extension RegisterServiceViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if self.provinceTextField.isEditing == true {
                setData(type: .province, id: "")
        } else if self.districtTextField.isEditing == true {
            guard let id = proId else {
                return
            }
            setData(type: .district, id: provinceList[id].gazcode)
        } else if self.communeTextField.isEditing == true {
            guard let id = disId else {
                return
            }
            setData(type: .commune, id: districtList[id].gazcode)
        } else if self.villageTextField.isEditing == true {
            guard let id = comId else {
                return
            }
            setData(type: .village, id: communeList[id].gazcode)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case provinceTextField, districtTextField, communeTextField, villageTextField:
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func fetchData(){
        DispatchQueue.main.async {
            self.crmViewModel.fetchRegisterPackage { (packageList) in
                self.packageList = packageList
            }
        }
    }
    
    func setData(type : ADDRESS, id : String){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = COLOR.RED
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        activeTextField.inputView = picker
        activeTextField.inputAccessoryView = toolBar
        
        DispatchQueue.main.async {
            self.crmViewModel.fetchRegisterPackage { (packageList) in
                self.packageList = packageList
            }
            self.saleViewModel.fetchAddress(addressType: type, id: id) { (list) in
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

    func addDoneButtonOnKeyboard() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = COLOR.BLUE
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        self.firstNameTextField.inputAccessoryView = toolBar
        self.firstNameTextField.autocorrectionType = .no
        self.lastNameTextField.inputAccessoryView = toolBar
        self.lastNameTextField.autocorrectionType = .no
        self.phoneNumberTextField.inputAccessoryView = toolBar
        self.phoneNumberTextField.autocorrectionType = .no
        self.homeStreetTextField.inputAccessoryView = toolBar
        self.homeStreetTextField.autocorrectionType = .no

    }

    func doneButtonAction() {
        self.firstNameTextField.resignFirstResponder()
        self.lastNameTextField.resignFirstResponder()
        self.phoneNumberTextField.resignFirstResponder()
        self.homeStreetTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset : UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardSize.size.height + 20
            scrollView.contentInset = contentInset
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
}
