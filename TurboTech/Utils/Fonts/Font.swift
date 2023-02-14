//
//  Font.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

struct Font {
    var type : FontType
    var size : FontSize
    init(type : FontType, size : FontSize) {
        self.type = type
        self.size = size
    }
    
    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
    }
    
    enum FontName : String {
        case QuicksandBold = "Quicksand-Bold"
        case QuicksandSemiBold = "Quicksand-Semibold"
        case QuicksandMedium = "Quicksand-Medium"
        case QuicksandRegular = "Quicksand-Regular"
        case QuicksandLight = "Quicksand-Light"
        
        case BattambangBold = "Battambang-Bold"
        case BattambangRegular = "Battambang-Regular"
    }
    
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value : Double {
            switch self {
            case .standard(let size) :
                return size.rawValue
            case .custom(let customSize) :
                return customSize
            }
        }
    }
    
    enum StandardSize : Double {
        case h1 = 20.0
        case h2 = 18.0
        case h3 = 16.0
        case h4 = 14.0
        case h5 = 12.0
        case h6 = 10.0
    }
    
}
