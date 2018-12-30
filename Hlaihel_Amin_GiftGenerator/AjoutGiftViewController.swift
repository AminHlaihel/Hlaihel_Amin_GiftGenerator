//
//  AjoutGiftViewController.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 29/12/2018.
//  Copyright © 2018 IF26. All rights reserved.
//

import UIKit
import SQLite

class AjoutGiftViewController: UIViewController {
    
    
    
    var database: Connection!
    let gifts_table = Table("gifts")
    let GIFT_id = Expression<Int64>("id")
    let nom = Expression<String>("nom")
    let category = Expression<String>("category")
    let type = Expression<String>("type")
    let prix = Expression<Int>("prix")
    
    
    
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
    
    
    
    var gift_name : String? = ""
    var gift_price : Int? = nil
    var gift_Type : String? = ""
    var gift_Category : String? = ""
    
    
    @IBOutlet weak var text_name: UITextField!
    @IBOutlet weak var text_price: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        do {let documentDirectory = try
            FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("gifts").appendingPathExtension("sqlite3")
            database = try Connection(fileUrl.path)
            
        }catch {
            print ("error with fileURL")
        }
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func radioFood(_ sender: Any) {
        gift_Type = TYPE_FOOD
    }
    
    
    @IBAction func radioJewlery(_ sender: Any) {
        gift_Type = TYPE_JEWLERY
    }
    
    
    @IBAction func radioType(_ sender: Any) {
        gift_Type = TYPE_TOYS
    }
    
    
    
    @IBAction func radioCatAutre(_ sender: Any) {
        gift_Category = CATEGORY_AUTRE
    }
    
    
    @IBAction func radioCatEnf(_ sender: Any) {
        gift_Category = CATEGORY_ENFANT
    }
    
    
    @IBAction func radioCatAmical(_ sender: Any) {
        gift_Category = CATEGORY_AMICAL
    }
    
    
    @IBAction func radioCatRom(_ sender: Any) {
        gift_Category = CATEGORY_ROMANTIQUE
    }
    
    
    @IBAction func radioCatTroll(_ sender: Any) {
        gift_Category = CATEGORY_TROLL
    }
    
    
    
    
    
    @IBAction func add_gift(_ sender: Any) {
        
        
        gift_name = text_name.text
        gift_price = Int(text_price.text!)
        
        if(gift_name != "" && gift_price != nil && gift_Category != "" && gift_Type != "" ){
            
            
            do{  try self.database.run(self.gifts_table.insert(nom <- gift_name!, category <- gift_Category!, type <- gift_Type!, prix <- gift_price!))
                print("insert success")
                showToast(message: "  Gift has been added")
            }catch{print("failed to insert")}
            
            
        }
        else{
    showToast(message: "  make sure that all cases are completed")
        }
        
        
        
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


extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x:   10, y: self.view.frame.size.height-100, width: self.view.frame.size.width-30, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .left;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 7.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
