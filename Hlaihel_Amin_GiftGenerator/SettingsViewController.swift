//
//  SettingsViewController.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 07/01/2019.
//  Copyright © 2019 IF26. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    
    @IBOutlet weak var textpass: UILabel!
    @IBOutlet weak var edtpass: UITextField!
    @IBOutlet weak var textvalidpass: UILabel!
    @IBOutlet weak var edtvalidpass: UITextField!
    @IBOutlet weak var btnvalider: UIButton!
    @IBOutlet weak var switchoutlet: UISwitch!
    
    
    
    var activated : Bool = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let colors = Colors()
        view.backgroundColor = UIColor.clear
        var backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        
        
        switchoutlet.isOn = false
        let preferences = UserDefaults.standard
        
        let passwordBool = "passwordBool"
        if preferences.object(forKey: passwordBool) == nil {
            //  Doesn't exist
            print("it doesn't exist")
        } else {
            let currentLevel = preferences.bool(forKey: passwordBool)
            activated = currentLevel
            switchoutlet.isOn = currentLevel
            print("bool is \(currentLevel)")
        }
        if(switchoutlet.isOn == false){
            
            textpass.isHidden = true
            textvalidpass.isHidden = true
            edtvalidpass.isHidden = true
            edtpass.isHidden = true
            btnvalider.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func switchClicked(_ sender: Any) {
        
        if(switchoutlet.isOn==false){
            //we turned it off
           // showToast(message: "it's off")
            let preferences = UserDefaults.standard
            let passwordBool = "passwordBool"
            let passwordboolsave = preferences.set(false, forKey: passwordBool)
            //  Save to disk
            let didSave = preferences.synchronize()
            if !didSave {
                //  Couldn't save (I've never seen this happen in real world testing)
            }
            textpass.isHidden = true
            textvalidpass.isHidden = true
            edtvalidpass.isHidden = true
            edtpass.isHidden = true
            btnvalider.isHidden = true
            
            
            
        }else{
            // we turned it on
            textpass.isHidden = false
            textvalidpass.isHidden = false
            edtvalidpass.isHidden = false
            edtpass.isHidden = false
            btnvalider.isHidden = false
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func btnvaliderClicked(_ sender: Any) {
        
        if(edtpass.text != "" && edtvalidpass.text != ""){
            if(edtpass.text == edtvalidpass.text){
                
                let preferences = UserDefaults.standard
                
                let password = "password"
                let passwordBool = "passwordBool"
                
                let currentLevel = preferences.set(edtpass.text, forKey: password)
                
                let passwordboolsave = preferences.set(true, forKey: passwordBool)
                
                //  Save to disk
                let didSave = preferences.synchronize()
                showToast(message: "Password updated")
                
                if !didSave {
                    //  Couldn't save (I've never seen this happen in real world testing)
                }
                
                
            }else{
                showToast(message: "make sure you enter the same password")
            }
            
        }else{
            showToast(message: " make sure you enter a password ")
        }
        
        
        
    }
    

}
