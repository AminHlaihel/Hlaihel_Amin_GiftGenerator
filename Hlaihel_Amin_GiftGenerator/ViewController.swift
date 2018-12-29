//
//  ViewController.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 28/12/2018.
//  Copyright © 2018 IF26. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{

    let locationMgr = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getLocation()
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
    
        
        
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
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            
                
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            
            }
            
            
            
            alert.addAction(okAction)
            print("i'm doing this 3")
            
            present(alert, animated: true ,completion: nil)
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
        
   /*
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude:currentLocation.coordinate.longitude, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        marker.title = "ME"
        marker.snippet = "France"
        marker.map = mapView
 */
        
        
    }
    
    // 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    

    
    
}

