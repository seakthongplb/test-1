//
//  VerifyLoginViewController.swift
//  TurboTech
//
//  Created by sq on 6/13/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Firebase

class VerifyLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var onTimeTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var scrollView : UIScrollView!
    
    private var activityIndicatorView = UIActivityIndicatorView()
    
    private var password : String!
    private var username : String!
    private var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        localize()
    }
    
    public func setUser(_ un : String, _ pa : String, _ us : User){
        password = pa
        username = un
        user = us
    }
    
    private func localize(){
        informationLabel.text = "please verify your code".localized
        confirmButton.setTitle("confirm".localized, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let u = user {
//            print(u.phone)
            sendVerifyCode(phone: u.phone)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.onTimeTextField.becomeFirstResponder()
        
    }
    
    private func setup(){
        confirmButton.isEnabled = false
        self.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UITextField.textDidChangeNotification, object: onTimeTextField)
        onTimeTextField.delegate = self
        onTimeTextField.becomeFirstResponder()
        
        setupNotification()
    }
    
    @objc func keyboardDidShow(notification : NSNotification){
        if onTimeTextField.text?.count == 6 {
            confirmButton.isEnabled = true
        } else {
            confirmButton.isEnabled = false
        }
    }
    
    
    @IBAction func confirmPressed(_ sender: Any) {
//        print("Nothing confirm")
        guard let code = onTimeTextField.text else {
//            print("NIL CODE")
            return
        }
        if code != "" {
            verification(verificationCode: code)
        }
    }
    
    private func sendVerifyCode(phone : String){
        let p = phone.phoneNumber
//        print(p)
        UserDefaults.standard.set(nil, forKey: "authVerificationID")
        // MARK: - Testing Number
//        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(p, uiDelegate: nil) { (verificationID, error) in
            
            if let error = error {
                self.showMessagePrompt(error.localizedDescription)
                UserDefaults.standard.set(nil, forKey: "authVerificationID")
                return
            }
//            print("VerificationID : ", verificationID ?? "WRONG ID")
            Auth.auth().languageCode = LanguageManager.shared.language
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            
        }
    }
    
    private func verification(verificationCode : String){
        showActivityIndicatory(actInd: activityIndicatorView, uiView: self.view)
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        if let verId = verificationID {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verId, verificationCode: verificationCode)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    print("Error in verification")
                    UserDefaults.standard.set(nil, forKey: "authVerificationID")
                    return
                } else {
                    print("User can login with code")
                    self.activityIndicatorView.stopAnimating()
                    User.setupUser(username: self.username, password: self.password, user: self.user)
                    let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileMainTableViewControllerID") as! ProfileMainTableViewController
                    self.navigationController?.viewControllers = [newVC]
                }
            }
        } else {
            UserDefaults.standard.set(nil, forKey: "authVerificationID")
            print("VerId is nil")
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewControllerID") as! LoginViewController
            self.navigationController?.viewControllers = [newVC]
        }
    }
}

extension VerifyLoginViewController {
    
    func setupNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addDoneButtonOnKeyboard() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = COLOR.BLUE
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        self.onTimeTextField.inputAccessoryView = toolBar
        self.onTimeTextField.autocorrectionType = .no

    }
    
    @objc func doneButtonAction() {
        self.onTimeTextField.resignFirstResponder()
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

private class SaveAlertHandle {
  static var alertHandle: UIAlertController?

  class func set(_ handle: UIAlertController) {
    alertHandle = handle
  }

  class func clear() {
    alertHandle = nil
  }

  class func get() -> UIAlertController? {
    return alertHandle
  }
}
