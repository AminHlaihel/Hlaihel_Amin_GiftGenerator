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

class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate,GMSPlacePickerViewControllerDelegate,UIApplicationDelegate{
   
    
    
    let TYPE_FOOD : String = "Food"
    let TYPE_JEWLERY : String = "Jewlery"
    let TYPE_TOYS : String = "Toys"
    let TYPE_WHATEVER : String = "Whatever"
    
    let CATEGORY_ENFANT : String = "Enfant"
    let CATEGORY_ROMANTIQUE : String = "Romantique"
    let CATEGORY_AMICAL : String = "Amical"
    let CATEGORY_TROLL : String = "Troll"
    let CATEGORY_AUTRE : String = "Autre"
    let CATEGORY_ALL : String = "All"
    

    

    
    
    var prix_max : Int = 0
    var type_choisis : String = "Whatever"
    var category_choisis : String = "All"
    
    
    @IBOutlet weak var prix_max_testField: UITextField!
    
    
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
    
    let giftnames : [String] = ["Giraffe","Teddy Bear","Meowsic Keyboard","Minion","Angry Pickachu","Pickachu","Edu Box","Wooden abacus","Digital Cube","Grumpy Cat","Empty Gift","Food Box","Macaron Box","Chocolate Box"]
    
    var tableExist = false   // false la table n'est encore pas créée


    let locationMgr = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getLocation()
    }
    
    override func viewDidLoad() {
        
        
        
        
        super.viewDidLoad()
        
        let colors = Colors()
        view.backgroundColor = UIColor.clear
        var backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        
        
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
            
            let firstLaunch = FirstLaunch()
            if firstLaunch.isFirstLaunch {
                /// do things
                print("first launch")
                
                do{  try self.database.run(self.gifts_table.insert(nom <- "Giraffe", category <- CATEGORY_ENFANT, type <- TYPE_TOYS, prix <- 10))
                    try self.database.run(self.gifts_table.insert(nom <- "Teddy Bear", category <- CATEGORY_ENFANT, type <- TYPE_TOYS, prix <- 19))
                    try self.database.run(self.gifts_table.insert(nom <- "Meowsic Keyboard", category <- CATEGORY_ENFANT, type <- TYPE_TOYS, prix <- 26))
                    try self.database.run(self.gifts_table.insert(nom <- "Minion", category <- CATEGORY_ENFANT, type <- TYPE_TOYS, prix <- 20))
                    try self.database.run(self.gifts_table.insert(nom <- "Angry Pickachu", category <- CATEGORY_ENFANT, type <- TYPE_TOYS, prix <- 24))
                    try self.database.run(self.gifts_table.insert(nom <- "Pickachu", category <- CATEGORY_TROLL, type <- TYPE_TOYS, prix <- 29))
                    try self.database.run(self.gifts_table.insert(nom <- "Edu Box", category <- CATEGORY_ENFANT, type <- TYPE_TOYS, prix <- 20))
                    try self.database.run(self.gifts_table.insert(nom <- "Wooden abacus", category <- CATEGORY_ENFANT, type <- TYPE_TOYS, prix <- 24))
                    try self.database.run(self.gifts_table.insert(nom <- "Digital Cube", category <- CATEGORY_ENFANT, type <- TYPE_TOYS, prix <- 12))
                    try self.database.run(self.gifts_table.insert(nom <- "Grumpy Cat", category <- CATEGORY_TROLL, type <- TYPE_TOYS, prix <- 24))
                    try self.database.run(self.gifts_table.insert(nom <- "Empty Gift", category <- CATEGORY_TROLL, type <- TYPE_TOYS, prix <- 3))
                    try self.database.run(self.gifts_table.insert(nom <- "Food Box", category <- CATEGORY_AMICAL, type <- TYPE_FOOD, prix <- 30))
                    try self.database.run(self.gifts_table.insert(nom <- "Macaron Box", category <- CATEGORY_AMICAL, type <- TYPE_FOOD, prix <- 15))
                    try self.database.run(self.gifts_table.insert(nom <- "Chocolate Box", category <- CATEGORY_ROMANTIQUE, type <- TYPE_FOOD, prix <- 35))
                    
                    
                    print("insert success")
                }catch{print("failed to insert")}
                
                
            }
            
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
    
    
    
    
    
    @IBAction func radioTypeWhat(_ sender: Any) {
        self.type_choisis = TYPE_WHATEVER
    }
    @IBAction func radioTypeFood(_ sender: Any) {
        self.type_choisis = TYPE_FOOD
    }
    @IBAction func radioTypeJewlery(_ sender: Any) {
        self.type_choisis = TYPE_JEWLERY
    }
    @IBAction func radioTypeToys(_ sender: Any) {
        self.type_choisis = TYPE_TOYS
    }
    
    
    
    @IBAction func radioCatAll(_ sender: Any) {
        self.category_choisis = CATEGORY_ALL
    }
    @IBAction func radioCatAutre(_ sender: Any) {
        self.category_choisis = CATEGORY_AUTRE
    }
    @IBAction func radioCatEnfant(_ sender: Any) {
        self.category_choisis = CATEGORY_ENFANT
    }
    @IBAction func radioCatAmical(_ sender: Any) {
        self.category_choisis = CATEGORY_AMICAL
    }
    @IBAction func radioCatRom(_ sender: Any) {
        self.category_choisis = CATEGORY_ROMANTIQUE
    }
    @IBAction func radioCatTroll(_ sender: Any) {
        self.category_choisis = CATEGORY_TROLL
    }
    
    
    
    @IBAction func generateGift(_ sender: Any) {
        
        self.generateaGift()
        
    }
    
    
    func generateaGift(){
        
        var gifts : [Gift] = []
        
        
        if(prix_max_testField.text?.isEmpty != true){
            self.prix_max = Int(prix_max_testField.text!)!
        }
        if(prix_max == 0 && type_choisis == TYPE_WHATEVER && category_choisis == CATEGORY_ALL){
            do{
                gifts.removeAll()
                for user in try self.database.prepare(gifts_table) {
                    let gift : Gift = Gift.init(nom:user[self.nom], category: user[self.category], prix: user[self.prix], type: user[self.type])
                    gifts.append(gift)
                    print("i added another gift")
                }
                
            }catch{
                print("error loading data from database 1")
            }
            
        }
        else if(prix_max == 0 && type_choisis != TYPE_WHATEVER && category_choisis == CATEGORY_ALL){
            do{
                gifts.removeAll()
                for user in try self.database.prepare(self.gifts_table.filter(type == type_choisis)) {
                    let gift : Gift = Gift.init(nom:user[self.nom], category: user[self.category], prix: user[self.prix], type: user[self.type])
                    gifts.append(gift)
                    print("i added another gift")
                }
                
            }catch{
                print("error loading data from database 2")
            }
            
        }
            
        else if(prix_max == 0 && type_choisis == TYPE_WHATEVER && category_choisis != CATEGORY_ALL){
            do{
                gifts.removeAll()
                for user in try self.database.prepare(self.gifts_table.filter(category == category_choisis)) {
                    let gift : Gift = Gift.init(nom:user[self.nom], category: user[self.category], prix: user[self.prix], type: user[self.type])
                    gifts.append(gift)
                    print("i added another gift")
                }
                
            }catch{
                print("error loading data from database 3")
            }
            
        }
            
        else if(prix_max == 0 && type_choisis != TYPE_WHATEVER && category_choisis != CATEGORY_ALL){
            do{
                gifts.removeAll()
                for user in try self.database.prepare(self.gifts_table.filter(type == type_choisis && category == category_choisis) ) {
                    let gift : Gift = Gift.init(nom:user[self.nom], category: user[self.category], prix: user[self.prix], type: user[self.type])
                    gifts.append(gift)
                    print("i added another gift")
                }
                
            }catch{
                print("error loading data from database 4")
            }
            
        }
        else if(prix_max != 0 && type_choisis == TYPE_WHATEVER && category_choisis == CATEGORY_ALL){
            do{
                gifts.removeAll()
                for user in try self.database.prepare(self.gifts_table.filter(prix <= prix_max)) {
                    let gift : Gift = Gift.init(nom:user[self.nom], category: user[self.category], prix: user[self.prix], type: user[self.type])
                    gifts.append(gift)
                    print("i added another gift")
                }
                
            }catch{
                print("error loading data from database 5")
            }
            
        }
            
        else if(prix_max != 0 && type_choisis == TYPE_WHATEVER && category_choisis != CATEGORY_ALL){
            do{
                gifts.removeAll()
                for user in try self.database.prepare(self.gifts_table.filter(prix <= prix_max && category == category_choisis) ) {
                    let gift : Gift = Gift.init(nom:user[self.nom], category: user[self.category], prix: user[self.prix], type: user[self.type])
                    gifts.append(gift)
                    print("i added another gift")
                }
                
            }catch{
                print("error loading data from database 6")
            }
            
        }
        else if(prix_max != 0 && type_choisis != TYPE_WHATEVER && category_choisis == CATEGORY_ALL){
            do{
                gifts.removeAll()
                for user in try self.database.prepare(self.gifts_table.filter(type == type_choisis && prix <= prix_max) ) {
                    let gift : Gift = Gift.init(nom:user[self.nom], category: user[self.category], prix: user[self.prix], type: user[self.type])
                    gifts.append(gift)
                    print("i added another gift")
                }
                
            }catch{
                print("error loading data from database 7")
            }
            
        }
        else if(prix_max != 0 && type_choisis != TYPE_WHATEVER && category_choisis != CATEGORY_ALL){
            do{
                gifts.removeAll()
                for user in try self.database.prepare(self.gifts_table.filter(type == type_choisis && category == category_choisis && prix <= prix_max) ) {
                    let gift : Gift = Gift.init(nom:user[self.nom], category: user[self.category], prix: user[self.prix], type: user[self.type])
                    gifts.append(gift)
                    print("i added another gift")
                }
                
            }catch{
                print("error loading data from database 4")
            }
            
        }
        else{
            print("WTF none of the above , WEIRD")
        }
        
        
        if(gifts.count != 0){
            var imageindex : Int = 0
            let number = Int.random(in: 0 ... gifts.count-1)
            //showToast(message: "your gift is \(gifts[number].nom) et le prix est \(gifts[number].prix)")
            
            
            while( imageindex < 14  && gifts[number].nom != giftnames[imageindex] ){
                print("imageindex is \(imageindex)")
                imageindex = imageindex+1
                
            }
            
            createAlertforGift(name: gifts[number].nom, prix: gifts[number].prix , imageindex : imageindex)
            
        }else{
            showToast(message: "there's no gift that validate these conditions :(")
        }
        
        
    }
    
    
    
    
    
    func createAlertforGift(name : String , prix : Int , imageindex : Int){
        
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self as? CustomAlertViewDelegate
        customAlert.name = name
        customAlert.prix = "\(prix)"
        customAlert.titre = "Your gift is "
        if(imageindex<14){
            customAlert.imageindex = imageindex
        }
    /*    customAlert.titelField.text = "Your gift is "
        customAlert.nameField.text = name
        customAlert.prixField.text = "\(prix)"*/
        self.present(customAlert, animated: true, completion: nil)
     /*      customAlert.titelField.text = "Your gift is "
         customAlert.nameField.text = name
         customAlert.prixField.text = "\(prix)"
        if(imageindex<14){
        customAlert.imageField.image = UIImage(named: "gift_number_\(imageindex+1)")
        }
 */
 // cell.icon_gift?.image = UIImage (named: "gift_number_\(indexPath.row+1)")
        
    }
    
    
    func pickaplace(){
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)    }
    
    
    

    
    
    
    
    
  
    
    
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

extension ViewController: CustomAlertViewDelegate {
    func cancelButtonTapped() {
        print("cancel chosen")
    }
    
    func randomButtonTapped() {
        self.generateaGift()
    }
    
    func pickButtonTapped() {
        self.pickaplace()
    }
    
    
  
}
