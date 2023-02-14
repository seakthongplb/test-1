//
//  Validation.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

class Validaton {
    static let shared = Validaton()
    func validationName(name : String) -> Bool {
        let nameRegex = "^\\w{2,18}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    func validaPhoneNumber(phoneNumber: String) -> Bool {
       let phoneNumberRegex = "^\\d{9,10}$"
       let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
       let validatePhone = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
       let isValidPhone = validatePhone.evaluate(with: trimmedString)
       return isValidPhone
    }
    func validateEmailId(emailID: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
       let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       let isValidateEmail = validateEmail.evaluate(with: trimmedString)
       return isValidateEmail
    }
    func validatePassword(password: String) -> Bool {
       //Minimum 8 characters at least 1 Alphabet and 1 Number:
       let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
       let trimmedString = password.trimmingCharacters(in: .whitespaces)
       let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
       let isvalidatePass = validatePassord.evaluate(with: trimmedString)
       return isvalidatePass
    }
    func validateAnyOtherTextField(otherField: String) -> Bool {
       let otherRegexString = "Your regex String"
       let trimmedString = otherField.trimmingCharacters(in: .whitespaces)
       let validateOtherString = NSPredicate(format: "SELF MATCHES %@", otherRegexString)
       let isValidateOtherString = validateOtherString.evaluate(with: trimmedString)
       return isValidateOtherString
    }
}
