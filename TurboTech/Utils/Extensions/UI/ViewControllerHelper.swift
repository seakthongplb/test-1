//
//  ViewControllerHelper.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import GoogleMaps

extension UIViewController {
    
    func showActivityIndicatory(actInd : UIActivityIndicatorView, uiView : UIView){
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)

        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.style =
            UIActivityIndicatorView.Style.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);

        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        container.tag = 101010
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    func removeActivityIndicatory(actId : UIActivityIndicatorView, uiView : UIView){
        if let fView = view.viewWithTag(101010) {
            fView.removeFromSuperview()
        }
        actId.stopAnimating()
    }
    
    func showMessagePrompt(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
      
    func showTextInputPrompt(withMessage message: String,
                             completionBlock: @escaping ((Bool, String?) -> Void)) {
        let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionBlock(false, nil)
        }
        weak var weakPrompt = prompt
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let text = weakPrompt?.textFields?.first?.text else { return }
            completionBlock(true, text)
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(cancelAction)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    func showAndDismissAlert(title : String?, message : String?, style : UIAlertController.Style, second : Double){
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        present(ac, animated: true)
        let time = DispatchTime.now() + second//second
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.dismiss(animated: true) { }
        }
    }
    
    func showAndDismissAlert(_ target : UIViewController, title : String?, message : String?, style : UIAlertController.Style, second : Double){
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        present(ac, animated: true)
        let time = DispatchTime.now() + second//second
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.dismiss(animated: true) { }
        }
    }
    
    func requestUserLocationAlert(_ target : UIViewController) {
        // Display the map using the default location.
        let alertController = UIAlertController(title: "Enable Location Service".localized, message: "Please go to Settings and turn on Location permissions".localized, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings".localized, style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .destructive){(action) in self.showAndDismissAlert(title: "Cannot Get Current Location".localized, message: "Please go to setting and enable it.".localized, style: .alert, second: 2)}
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)

        // check the permission status
        switch(CLLocationManager.authorizationStatus()) {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Authorize.")
                //  get the user location
            case .notDetermined, .restricted, .denied:
                //  redirect the users to settings
                self.present(alertController, animated: true, completion: nil)
            default :
                print("Default")
      }
    }
}
