//
//  FeedBackViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import iOSDropDown

class FeedBackViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var problemTypeLabel: UILabel!
    @IBOutlet weak var problemDetailLabel: UILabel!
    
    @IBOutlet weak var complainTypeDropDown: DropDown!
    @IBOutlet weak var complainTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!

    let lang = LanguageManager.shared.language
    var ids = [Int]()
    var titlesKh = [String]()
    var titlesEn = [String]()
    
    var problemTypeList = [ProblemType]()
    override func viewDidLoad() {
        super.viewDidLoad()
        localized()
        fetchData()
    }

    func localized(){
        titleLabel.text = "problem complain".localized
        problemTypeLabel.text = "problem type".localized
        problemDetailLabel.text = "problem detail".localized
        submitButton.setTitle("submit".localized, for: .normal)
    }
    
    func fetchData(){
        let helpDeskViewModel = HelpDeskViewModel()
        DispatchQueue.main.async {
            helpDeskViewModel.fetchProblemType { (problemTypes) in
                self.problemTypeList = problemTypes
                self.setupDropDown()
//                print(problemTypes.count)
            }
        }
    }
    
    func setupDropDown(){
        complainTextView.delegate = self
        for type in self.problemTypeList {
            ids.append(type.id)
            titlesEn.append(type.nameEn)
            titlesKh.append(type.nameKh)
        }

        complainTypeDropDown.text = lang == "en" ? titlesEn[0] : titlesKh[0]
        complainTypeDropDown.optionArray = lang == "en" ? titlesEn : titlesKh
        complainTypeDropDown.selectedRowColor = .red
        complainTypeDropDown.selectedIndex = 0
        submitButton.setTitle("Submit", for: .highlighted)
        submitButton.layer.cornerRadius = SIZE.RADIUS_BUTTON
        complainTextView.layer.cornerRadius = SIZE.RADIUS_CARD
        complainTypeDropDown.layer.cornerRadius = SIZE.RADIUS

        complainTypeDropDown.didSelect{(selectedText , index ,id) in
            self.complainTypeDropDown.text = ""//.localized
            self.complainTypeDropDown.tag = index
        }
    }
    
    @IBAction func submitComplainPress(_ sender: Any) {
        let helpDeskViewModel = HelpDeskViewModel()
        let complain = UserComplain(type: "", question: "")
        complain.setType(type: self.titlesEn[self.complainTypeDropDown.tag])
        complain.setQuestion(question: complainTextView.text ?? "")
//        print("user text : ", complain.question)
        
        DispatchQueue.main.async {
            helpDeskViewModel.postComplainMessage(complain: complain) { (message) in
                let shMsg = self.lang == "en" ? "\(self.titlesEn[self.complainTypeDropDown.tag]) " + "problem".localized : "problem".localized + " \(self.titlesKh[self.complainTypeDropDown.tag])"
                self.showAndDismissAlert(title: shMsg, message: message.localized, style: .alert, second: 2)
//                print(message)
            }
        }
    }
}


extension FeedBackViewController : UITextFieldDelegate {
  // when user select a textfield, this method will be called
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // set the activeTextField to the selected textfield
//    self.complainTypeTextField = textField
  }
    
  // when user click 'done' or dismiss the keyboard
  func textFieldDidEndEditing(_ textField: UITextField) {
//    self.complainTypeTextField = nil
  }
}

extension FeedBackViewController : UITextViewDelegate {
    
}
