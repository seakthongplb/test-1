//
//  InternetConnection.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import Network

class InternetConnection {
    
    static let shared = InternetConnection()
    var isConnected = false
    var isReconnect = false
    var isLogin : Bool = false
    
    func checkConnection(_ target : UIViewController, completion: @escaping(Bool)->()){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
//                print("Internet connection is on.")
                self.isConnected = true
//                can fetch user data
            }
            else {
//                cannot fetch user data
                if self.isReconnect {
                    self.checkConnection(target) { (status) in
//                        print("status : ", status)
                    }
                    self.isReconnect = false
                } else {
                    self.isReconnect = true
//                    print("There's no internet connection.")
                    DispatchQueue.main.async {
                        target.showAndDismissAlert(target, title: "No Internet Connection".localized, message: "Check Your Connection please!".localized, style: .alert, second: 5)
                    }
                }
            }
        }
        
        if self.isConnected == true {
            fetchData { (status) in
                completion(status)
                self.isLogin = status
            }
            
        }
        
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.start(queue: queue)
    }
    
    func fetchData(completion: @escaping(Bool)->()){
        DispatchQueue.main.async {
            let loginViewModel = LoginViewModel()
            loginViewModel.fetchCurrentUser { (status) in
                completion(status)
            }
        }
    }
    
}
