//
//  ResponderHelper.swift
//  TurboTech
//
//  Created by sq on 7/14/20.
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

extension UIResponder {
    func setupMulipleTextField(
        _ textFields : [UITextField?],
        tag : Int,
        picker : UIView,
        toolBar : UIToolbar,
        autoCorrection : UITextAutocorrectionType = .no,
        returnKeyType : UIReturnKeyType = .next,
        dropDownIndex : Int...
    ){
        for index in 0..<textFields.count {
            let textField = textFields[index]
            textField?.tag = (tag * (index + 1))
            textField?.customizeRegister()
            if dropDownIndex.count != 0 {
                if dropDownIndex.contains(index) {
                    textField?.setDropDownImage()
                    textField?.inputView = picker
                }
            }
            textField?.inputAccessoryView = toolBar
            textField?.autocorrectionType = autoCorrection
            textField?.returnKeyType = returnKeyType
        }
        textFields[textFields.count-1]?.returnKeyType = .done
    }
}

