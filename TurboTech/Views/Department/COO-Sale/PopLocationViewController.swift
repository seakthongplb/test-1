//
//  PopLocationViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import iOSDropDown
import MapKit

class PopLocationViewController: UIViewController {
    
    let lang = LanguageManager.shared.language

    let saleViewModel = SaleViewModel()
    var popList = [POP]()
    var selectOption = ["All"]
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15
    var zoomOverAllLevel : Float = 6.5
    
    let defaultLocation = CLLocation(latitude: 12.542099, longitude: 104.815518)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap()
        fetchData()
    }
    
    func setMap(){
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomOverAllLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.isHidden = true
    }
    
    func fetchData(){
        DispatchQueue.main.async {
            self.saleViewModel.fetchAllPop { (pop) in
                self.popList = pop
                self.setPop()
            }
        }
    }
    
    func setPop(){
        selectOption = ["all".localized]
        popList.forEach { (pop) in
            pinPop(pop: pop)
            selectOption.append(lang == "en" ? pop.nameEn : pop.nameKh)
        }
        addRightNavItem()
//        self.moveOverall()
    }
    
    func moveOverall(){
        let cameraAll = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomOverAllLevel)
        mapView.camera = cameraAll
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func pinPop(pop : POP){
        let position = CLLocationCoordinate2D(latitude: (pop.latitude*1000000)/1000000, longitude: (pop.longitude*1000000)/1000000)
        let marker = GMSMarker(position: position)
        marker.title = "\(lang == "en" ? pop.nameEn : pop.nameKh)"
        var pop = UIImage(named: "pop_1x")
        pop = pop?.imageResize(sizeChange: CGSize(width: 32, height: 48))
        marker.icon = pop
        marker.map = mapView
        marker.appearAnimation = .pop
    }
    
    func addRightNavItem(){
        self.navigationItem.title = ""
        let rNavVIew = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        
        let dropdown = DropDown(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        dropdown.textAlignment = .left
        dropdown.text = "all".localized
        dropdown.font = UIFont.systemFont(ofSize: NAV.HOME_NAV_TITLE_SIZE, weight: .semibold)
        dropdown.textColor = NAV.HOME_NAV_COLOR_WHITE
        
        dropdown.delegate = self
        dropdown.optionArray = selectOption
        dropdown.selectedRowColor = .red
        dropdown.selectedIndex = 0
        dropdown.listHeight = 240
        dropdown.didSelect{(selectedText , index ,id) in
            if index > 0 {
//                print("WORK zero")
                let selectedPop = self.popList[index - 1]
                let camera = GMSCameraPosition.camera(withLatitude: selectedPop.latitude, longitude: selectedPop.longitude, zoom: self.zoomLevel)
                self.mapView.camera = camera
                self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            } else {
//                print("WORK Else")
                let camera = GMSCameraPosition.camera(withLatitude: self.defaultLocation.coordinate.latitude, longitude: self.defaultLocation.coordinate.longitude, zoom: self.zoomOverAllLevel)
                self.mapView.camera = camera
                self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            }
        }
        
        rNavVIew.addSubview(dropdown)
        let leftBarButton = UIBarButtonItem(customView: rNavVIew)
        self.navigationItem.rightBarButtonItem = leftBarButton
    }

}


// Delegates to handle events for the location manager.
extension PopLocationViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomOverAllLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }

  // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .restricted:
                print("Location access was restricted.")
                fallthrough
                case .denied:
                print("User denied access to location.")
                // Display the map using the default location.
                let alertController = UIAlertController(title: "enable location service".localized, message: "please go to settings and turn on location permissions".localized, preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "settings".localized, style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                    }
                }
          
                let cancelAction = UIAlertAction(title: "cancel".localized, style: .destructive){(action) in self.showAndDismissAlert(title: "cannot get current location".localized, message: "please go to setting and enable it.".localized, style: .alert, second: 2)}
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
                mapView.isHidden = false
            case .notDetermined:
                print("Location status not determined.")
            case .authorizedAlways: fallthrough
            case .authorizedWhenInUse:
                print("Location status is OK.")
            @unknown default:
                fatalError()
        }
    }

  // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
//        print("Error: \(error)")
    }
}

extension PopLocationViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        false
    }
}

extension PopLocationViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        print("tapped on marker")
        popList.forEach { (pop) in
            if marker.title == pop.nameEn || marker.title == pop.nameKh {
//                print(pop.nameKh, pop.code)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopDetailViewControllerID") as! PopDetailViewController
                vc.id = pop.code
                vc.popName = lang == "en" ? pop.nameEn : pop.nameKh
                if #available(iOS 13.0, *){
                    self.present(vc, animated: true, completion: nil)
                } else {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        return true
    }
}
