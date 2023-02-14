//
//  LateExceptionViewController.swift
//  TurboTech
//
//  Created by wo on 9/29/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import LGButton

class LateExceptionViewController: UIViewController {

    @IBOutlet weak var alertView : UIView!
    @IBOutlet weak var reasonLabel : UILabel!
    @IBOutlet weak var reasonTextField : UITextField!
    @IBOutlet weak var exceptionLGButton : LGButton!
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var confirmButton : UIButton!
    
    var onReloadBack : ((_ isReload : Bool)->())?
    
    var editData : AttendancePresent?
    var isCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        self.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
        guard  let data = self.editData else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.reasonLabel.text = "\("reason on".localized) \(data.name)"
    }
    
    @IBAction func exceptionPressed(_ sender : LGButton){
        isCheck.toggle()
        self.exceptionLGButton.leftImageSrc = UIImage(named: isCheck ? "check-square" : "square")
    }
    
    @IBAction func buttonPressed(_ sender : UIButton){
        switch sender {
        case cancelButton :
            self.dismiss(animated: true, completion: nil)
        case confirmButton :
            DispatchQueue.main.async {
                guard let user = AppDelegate.user, let data = self.editData else { return }
                let viewmodel = AttandanceViewModel()
                let exc = LateException(isException: self.isCheck, description: self.reasonTextField.text ?? "", maUserId: "\(data.id)", userId: user.id)
                viewmodel.postException(exception: exc) { (status) in
                    print(status)
                    if status {
                        self.dismiss(animated: true) {
                            if let onDone = self.onReloadBack {
                                onDone(true)
                            }
                        }
                    }
                }
            }
        default:
            print("DEF")
        }
    }
    
}
