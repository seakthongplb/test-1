//
//  Enum.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit

enum DeviceTraitStatus {
    case wRhR
    case wChR
    case wRhC
    case wChC

    static var current:DeviceTraitStatus{

        switch (UIScreen.main.traitCollection.horizontalSizeClass, UIScreen.main.traitCollection.verticalSizeClass){

        case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular):
            return .wRhR
        case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.regular):
            return .wChR
        case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.compact):
            return .wRhC
        case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.compact):
            return .wChC
        default:
            return .wChR

        }
    }
}
