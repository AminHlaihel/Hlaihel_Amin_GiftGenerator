//
//  ViewController.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 28/12/2018.
//  Copyright © 2018 IF26. All rights reserved.
//

import UIKit
import CoreLocation
import SQLite
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate,GMSPlacePickerViewControllerDelegate{
   
    
    
    var mapViewC : MapViewController?
    
    var database: Connection!
    let gifts_table = Table("gifts")
    let GIFT_id = Expression<Int64>("id")
    let nom = Expression<String>("nom")
    let category = Expression<String>("category")
    let type = Expression<String>("type")
    let prix = Expression<Int>("prix")
    
    var myLocation : CLLocation? = nil
    var myLocationBool : Bool = false
  weak var delegate:MapDelegate?
    
    var tableExist = false   // false la table n'est encore pas créée


    let locationMgr = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getLocation()
    }
    
    override func viewDidLoad() {
        
        
        
        
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        print ("--> viewDidLoad debut")
        // Il est possible de créer des fichiers dans le répertoire "Documents" de votre application.
        // Ici, création d'un fichier users.sqlite3
        do {let documentDirectory = try
            FileManager.default.url(for: .documentDirectory,                               in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("gifts").appendingPathExtension("sqlite3")
            let base = try Connection(fileUrl.path)
            self.database = base;
            
        }catch {
            print ("error")
        }
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        do {// Exécution du create si la table n'existe pas
            
            try self.database.run(self.gifts_table.create( ifNotExists: true) { table in
                table.column(self.GIFT_id, primaryKey: true)
                table.column(self.nom)
                table.column(self.category)
                table.column(self.type)
                table.column(self.prix) })
            print ("Table users est créée")
            self.tableExist = true;
            
            
            // insert les elements du base
         
       /*     do{  try self.database.run(self.gifts_table.insert(nom <- "test", category <- "test category", type <- "testtype", prix <- 25))
                print("insert success")
            }catch{print("failed to insert")}
            
            */
        }
        catch {
            print ("error")
            
        }
        
        
    
    print ("--> viewDidLoad fin")
        
        
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
    }
    
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        addDestination(name: place.name, lat: place.coordinate.latitude, long: place.coordinate.longitude)
        
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
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
        self.myLocation = currentLocation
        self.myLocationBool = true
        print("Current location: \(currentLocation)")
        
        updateMap(location: currentLocation)
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
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let baseTabBarVC = segue.destination as? UITabBarController {
            if let firstTab = baseTabBarVC.viewControllers?.first as? MapViewController {
                firstTab.delegate = self.delegate
            }
            
        }
        if let vc = segue.destination as? MapViewController {
            mapViewC = vc
        }
    }
    
    
    func updateMap(newLocation : CLLocation) {
        print ("i'm updating the location")
    }
    
    
    @IBAction func tryingupdate(_ sender: Any) {
       
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)

    }
    
  
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        // Application is back in the foreground
        getLocation()
        print("active")
    }
    
}


extension ViewController: MapDelegate {
    func updateMap(location: CLLocation) {
        print("doing update location from ViewController")
        mapViewC?.updateMyLocation(newLocation: location)
     
        
    }
    
    func addDestination(name: String, lat: Double, long: Double) {
        print("sending destination")
        mapViewC?.addDestination(name: name, lat: lat, long: long)
    }
}

