//
//  MapViewController.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 28/12/2018.
//  Copyright © 2018 IF26. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class MapViewController: UIViewController, CLLocationManagerDelegate{

    let locationMgr = CLLocationManager()
    var mapView : GMSMapView? = nil
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
         mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        getLocation()
        // Creates a marker in the center of the map.
 //       let marker = GMSMarker()
  //      marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
  //      marker.title = "Sydney"
  //      marker.snippet = "Australia"
   //     marker.map = mapView
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access lol")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
    }
    

    
    
    
    func getLocation() {
        // 1
        let status  = CLLocationManager.authorizationStatus()
        print("i'm doing this 1")
        
        // 2
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            print("i'm doing this 2")
            return
        }
        
        // 3
        if status == .denied || status == .restricted {
            
            /*
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            
            present(alert, animated: true)
 */
            
            print("i'm doing this 3")
            return
        }
        
        // 4
        locationMgr.delegate = (self as CLLocationManagerDelegate)
        locationMgr.startUpdatingLocation()
    }
    
    
    // 1
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        print("Current location: \(currentLocation)")
        
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude:currentLocation.coordinate.longitude, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
              let marker = GMSMarker()
             marker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
             marker.title = "ME"
             marker.snippet = "France"
            marker.map = mapView
        
        
    }
    
    // 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    

  
    override func viewDidDisappear(_ animated: Bool) {
        getLocation()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
