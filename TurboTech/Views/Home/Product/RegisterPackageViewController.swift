//
//  RegisterPackageViewController.swift
//  TurboTech
//
//  Created by sq on 7/17/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

class RegisterPackageViewController: UIViewController {

    @IBOutlet weak var firstnameTextField : UITextField!
    @IBOutlet weak var lastnameTextField : UITextField!
    @IBOutlet weak var phoneNumberTextField : UITextField!
    @IBOutlet weak var doneButton : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var alertView : UIView!
    @IBOutlet weak var gesture : UIGestureRecognizer!
    lazy var packageDetailViewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor(white: 0.75, alpha: 0.4)
        self.view.addGestureRecognizer(gesture)
        packageDetailViewModel.productViewModelDelegate = self
    }
    
    @IBAction func donePressed(_ sender : Any) {
        guard let firstname = firstnameTextField.text, let lastname = lastnameTextField.text, let phone = phoneNumberTextField.text else { return }
        if firstname == "" || lastname == "" || phone == "" {
            return
        } else {
//            print("WORK HERE")
            packageDetailViewModel.postRegisterNewService(firstname, lastname, phone)
        }
    }
    
    @IBAction func cancelPressed(_ sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewGesturePressed(_ sender: UITapGestureRecognizer) {
        let posX = sender.location(in: view.self).x;
        let posY = sender.location(in: view.self).y;
        let minX = alertView.frame.minX;
        let maxX = alertView.frame.maxX;
        let minY = alertView.frame.minY;
        let maxY = alertView.frame.maxY;
        if ( (posX >= minX && posX <= maxX) && (posY >= minY && posY <= maxY) ) == false{
            self.dismiss(animated: true, completion: nil);
        }
    }
}

extension RegisterPackageViewController  : ProductViewModelDelegate {
    func responseMessage(_ message: String) {
//        print("Hello Hello : \(message)")
        self.dismiss(animated: true, completion: nil)
    }
    
    func responseSoftwareSolution(solutions: [SoftwareSolution]) {
        
    }
    
    func responseProduct(products: [Product]) {
        
    }
    
    func responsePackage(packages: [Package]) {
        
    }
    
    func responsePackageDetail(packageDetails: [PackageDetail]) {
        
    }
    
    
}


