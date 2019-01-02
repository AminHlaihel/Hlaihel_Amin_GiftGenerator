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
import SwiftyJSON

class MapViewController: UIViewController, CLLocationManagerDelegate{

    
    var viewC : ViewController?
    
    let locationMgr = CLLocationManager()
    var mapView : GMSMapView? = nil
    
    var myLocation : CLLocation? = nil
    var myLocationBool : Bool = false
    var myDestination : LongLatName?
    weak var delegate:MapDelegate?
    var myMap : GMSMapView?
    var myMarker : GMSMarker?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
      
        //Setting the googleView
    /*   view.camera = camera
        self.googleView.delegate = self
        self.googleView?.isMyLocationEnabled = true
        self.googleView.settings.myLocationButton = true
        self.googleView.settings.compassButton = true
        self.googleView.settings.zoomGestures = true
        self.googleView.animate(to: camera)
        self.view.addSubview(self.googleView)
        */
        
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        getLocation()
        if(myLocationBool == true){
            let camera = GMSCameraPosition.camera(withLatitude: (myLocation?.coordinate.latitude)! ,longitude: (myLocation?.coordinate.longitude)! , zoom: 6.0)
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            view = mapView
            
            self.myMap = mapView
            
            self.myMap?.isMyLocationEnabled = true
            self.myMap?.settings.myLocationButton = true
        }else{
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
         mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
            
            
        }
        
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
        self.myLocation = currentLocation
        self.myLocationBool = true
        print("Current location: \(currentLocation)")
        
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude:currentLocation.coordinate.longitude, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
              let marker = GMSMarker()
             marker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
             marker.title = "ME"
             marker.snippet = "France"
        //    marker.map = mapView
        
       // self.myMarker = marker
       self.myMap = mapView
        
        self.myMap?.isMyLocationEnabled = true
        self.myMap?.settings.myLocationButton = true
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
    
    func updateMyLocation(newLocation : CLLocation) {
        self.myLocation = newLocation
        print("my Location has been updated")
        
        let camera = GMSCameraPosition.camera(withLatitude: newLocation.coordinate.latitude, longitude:newLocation.coordinate.longitude, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        marker.title = "ME"
       // marker.map = mapView
      
        self.myMap = mapView
        
        
        self.myMap?.isMyLocationEnabled = true
        self.myMap?.settings.myLocationButton = true
    }
    
    func addDestination(name : String , lat : Double , long : Double){
        self.myDestination = LongLatName.init(nom: name, longlat: CLLocationCoordinate2D.init(latitude: lat, longitude: long))
        
        print("my destination has been updated")
        print("")
        
        
        self.myMap!.clear()
        
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (myLocation?.coordinate.latitude)!, longitude: (myLocation?.coordinate.longitude)!)
        marker.icon = GMSMarker.markerImage(with: UIColor.green)
        marker.title = "Me"
        marker.map = self.myMap
        
        //28.643091, 77.218280
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker1.title = name
        marker1.map = self.myMap
        
        
        

        getPolylineRoute(from: (myLocation?.coordinate)!, to: (myDestination?.longlat)!)
        
        
        
        
        
        
        
    }
    

    // Pass your source and destination coordinates in this method.
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=AIzaSyBPj8BemFfzR9SNqKnudsXjBhBZg7AKh6c")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                   // self.mapView.clear()
                    
                    OperationQueue.main.addOperation({
                        for route in routes
                        {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3
                            
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            
                            polyline.map = self.mapView
                            
                        }
                    })
                }catch let error as NSError{
                    print("error:\(error)")
                }
            }
        })
        task.resume()
    }
    
    
/*    func showPath(polyStr :String){
        let path = GMSPath.init(fromEncodedPath: polyStr)
        let polyline = GMSPolyline.init(path: path)
        polyline.strokeColor = UIColor.blue
        polyline.strokeWidth = 2
        polyline.map = self.myMap
    }*/
    
}
    




