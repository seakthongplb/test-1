//
//  File.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import Foundation

class Menu {
    var id : Int = 0
    var imageUrl : String = "4.jpg"
    var title : String = "N/A"
    
    init(id : Int, title : String = "N/A", imageUrl : String = "4.jpg") {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
    }
    
}
