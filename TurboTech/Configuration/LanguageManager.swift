//
//  LanguageManager.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation
import UIKit
class LanguageManager {
    static let shared = LanguageManager()
    var language : String {
        get {
            if let lang = UserDefaults.standard.string(forKey: "LanguageCode"){
                return lang
            } else {
                return "km"
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LanguageCode")
        }
    }
    
    var fontName : String {
        get {
            switch language {
            case "en" : return "QuickSand"
            case "km" : return "Battambang"
            default : return "Battambang"
            }
        }
    }
}

extension String {

    var localized : String {

        let path = Bundle.main.path(forResource: LanguageManager.shared.language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        let translated = (bundle?.localizedString(forKey: self, value: nil, table: nil))!
        return translated

    }

}
