//
//  UserCheckedInLocationViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class UserCheckedInLocationViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var lat : Double?
    var lng : Double?
//    var zoomWorld : Float = 1.0
//    var zoomLandMass : Float = 5.0
//    var zoomCity : Float = 10.0
//    var zoomStreet : Float = 15.0
//    var zoomStreetBuilding : Float = 17.5
//    var zoomBuilding : Float = 20.0
    let geocoder = GMSGeocoder()

    var onDismissHandle : ((_ lat : Double, _ lng : Double) -> Void)?
    
    var currentSearchCoordinator : CLLocationCoordinate2D?
    
    var destinationMarker : GMSMarker?

    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    let defaultLocation = CLLocation(latitude: 11.620456, longitude: 104.891839)
    
    
//    MARK: - Search Auto
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
//    MARK: - END
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
        
        // Create a map.
        var camera : GMSCameraPosition!
        if let old = currentSearchCoordinator {
            moveCamera(coordination: old)
            camera = GMSCameraPosition.camera(withLatitude: old.latitude,
            longitude: old.longitude,
            zoom: zoomLevel)
        } else {
            camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
            longitude: defaultLocation.coordinate.longitude,
            zoom: zoomLevel)
        }
        
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self

        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
//        makeButton()
//        MARK: - START SEARCH
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController

        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.tintColor = .black
        searchController?.searchBar.textField?.backgroundColor = .white
        navigationItem.titleView = searchController?.searchBar

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true

        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
//        MARK: - END
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print("DisAppear hz lol")
        if let cl = currentSearchCoordinator {
            onDismissHandle!(cl.latitude, cl.longitude)
        }
        
    }
    
    func moveCamera(coordination : CLLocationCoordinate2D){
//        let camera = GMSCameraPosition.camera(withLatitude: coordination.latitude, longitude: coordination.longitude, zoom: self.zoomStreetBuilding)
//        self.mapView.camera = camera
//        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.clear()
//        print("Did tap at : ", coordination)
        currentSearchCoordinator = coordination
        let marker = GMSMarker(position: coordination)
        marker.title = "here"
        marker.map = mapView
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked(_ sender: UIButton) {
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self

      // Specify the place data types to return.
      let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.placeID.rawValue))
      autocompleteController.placeFields = fields

      // Specify a filter.
      let filter = GMSAutocompleteFilter()
      filter.type = .address
      autocompleteController.autocompleteFilter = filter

      // Display the autocomplete view controller.
      present(autocompleteController, animated: true, completion: nil)
    }

    // Add a button to the view.
    func makeButton() {
      let btnLaunchAc = UIButton(frame: CGRect(x: 5, y: 150, width: 300, height: 35))
      btnLaunchAc.backgroundColor = .blue
      btnLaunchAc.setTitle("Launch autocomplete", for: .normal)
      btnLaunchAc.addTarget(self, action: #selector(autocompleteClicked), for: .touchUpInside)
      self.view.addSubview(btnLaunchAc)
    }

}

// Delegates to handle events for the location manager.
extension UserCheckedInLocationViewController: CLLocationManagerDelegate {
    
  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
//    print("Location: \(location)")
    
    // MARK: - Move Map to Move Market
//    destinationMarker = GMSMarker(position: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude))
//    if let marker = destinationMarker {
//        marker.title = "Hello World"
//        marker.map = mapView
//    }
    // MARK: - End move map to move marker
    
    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)

    if mapView.isHidden {
      mapView.isHidden = false
      mapView.camera = camera
    } else {
      mapView.animate(to: camera)
    }
  }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        print("position target : ", position.target)
        geocoder.reverseGeocodeCoordinate(position.target) { (response, error) in
            guard error == nil else {
              return
            }
            if let result = response?.firstResult() {
                result.lines?.forEach({ (str) in
//                    print("str : " , str)
                })
//                print(result)
            }
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
      self.requestUserLocationAlert(self)
      // Display the map using the default location.
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
//    print("Error: \(error)")
  }
    
    
}

extension UserCheckedInLocationViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        print("TAP : ", coordinate)
        moveCamera(coordination: coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        destinationMarker?.position = position.target
    }
}


extension UserCheckedInLocationViewController : GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    currentSearchCoordinator = place.coordinate
    // MARK: - Using When move map
//    updateLocationoordinates(coordinates: place.coordinate)
//    print("Place name: \(place.name)")
//    print("Place ID: \(place.placeID)")
//    print("Place attributions: \(place.attributions)")
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}

// MARK: - Search
// Handle the user's selection.
extension UserCheckedInLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
    searchController?.isActive = false
    currentSearchCoordinator = place.coordinate
    moveCamera(coordination: place.coordinate)
//    print("Coordinate : ", place.coordinate)
//    print("Place name: \(place.name)")
//    print("Place address: \(place.formattedAddress)")
//    print("Place attributions: \(place.attributions)")
  }

  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error){
//    print("Error: ", error.localizedDescription)
  }
}

extension UISearchBar {

    var textField : UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            for view : UIView in (self.subviews[0]).subviews {
                if let textField = view as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
}
