//
//  UserLocationViewController.swift
//  TurboTech
//
//  Copyright © 2020 TurboTech. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class LocationViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 16.5
    
    let defaultLocation = CLLocation(latitude: 11.620456, longitude: 104.891839)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "location".localized
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
        
        locationManager.requestAlwaysAuthorization()
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true

        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
    }

}


// Delegates to handle events for the location manager.
extension LocationViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
//        let coordinates = [
//            CLLocationCoordinate2D(latitude: 11.620557, longitude: 104.891867),
//            CLLocationCoordinate2D(latitude: 11.620157, longitude: 104.891067),
//            CLLocationCoordinate2D(latitude: 11.620360, longitude: 104.891356)
//        ]
        
//        let locations = [
//            CLLocation(latitude: 11.620557, longitude: 104.891867),
//            CLLocation(latitude: 11.620360, longitude: 104.891356)
//        ]
//
//        print("#002 : \(locations[0].distance(from: locations[1]))")
        
//        let path = GMSMutablePath()
//        for coord in coordinates {
//            path.add(coord)
//        }
        
//        let line = GMSPolyline(path: path)
//        line.strokeColor = UIColor.red
//        line.strokeWidth = 3.0
//        line.map = self.mapView
        
//        print("#001 : \(DistanceLatLng.shared.getDistanceM(coordinates))" )
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
        print("Error: \(error)")
    }
}


class DistanceLatLng {
    static var shared = DistanceLatLng()
    
    private init(){}
    
    private func deg2rad(_ deg : Double) -> Double {
        return deg * Double.pi / 180
    }
    
    private func rad2deg(_ rad : Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    
    private func distance(_ lat1 : Double, _ lon1 : Double, _ lat2 : Double, _ lon2 : Double, _ unit : String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta))
        dist = acos(dist)
        dist = rad2deg(dist)
        dist = dist * 60 * 1.1515
        if (unit == "km") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist
    }
    
    func getDistanceM(_ list : [CLLocationCoordinate2D]) -> Double{
        var distance : Double = 0.0
        for i in 0..<(list.count-1) {
            distance += self.distance(Double(list[i].latitude), Double(list[i].longitude), Double(list[i+1].latitude), Double(list[i+1].longitude), "km")
        }
        return distance * 1000
    }
}
