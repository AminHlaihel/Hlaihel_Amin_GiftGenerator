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

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    var database: Connection!
    let gifts_table = Table("gifts")
    let GIFT_id = Expression<Int64>("id")
    let nom = Expression<String>("nom")
    let category = Expression<String>("category")
    let type = Expression<String>("type")
    let prix = Expression<Int>("prix")
    
    var tableExist = false   // false la table n'est encore pas créée


    let locationMgr = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getLocation()
    }
    
    override func viewDidLoad() {
        
        
        
        
        super.viewDidLoad()
        
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

