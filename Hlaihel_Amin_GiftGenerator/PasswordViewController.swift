//
//  PasswordViewController.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 07/01/2019.
//  Copyright © 2019 IF26. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    @IBOutlet weak var buttonpassage: UIButton!
    
    let passwordBoolKey = "passwordBool"
    let passKey = "password"
    
    var passBool : Bool?
    var pass : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonpassage.isHidden = true
        let colors = ColorsBlue()
        view.backgroundColor = UIColor.clear
        var backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        // Do any additional setup after loading the view.
        
        
       
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var passed : Bool = false
        let preferences = UserDefaults.standard
        if preferences.object(forKey: self.passwordBoolKey) == nil {
            //  Doesn't exist
            print("it doesn't exist")
        } else {
            let currentLevel = preferences.bool(forKey: passwordBoolKey)
            passBool = currentLevel
            print("bool is \(currentLevel)")
        }
        
        if(passBool == true){
            
            if preferences.object(forKey: self.passKey) == nil {
                //  Doesn't exist
                print("it doesn't exist")
            } else {
                let currentLevel = preferences.string(forKey: passKey)
                pass = currentLevel
                print("password is \(currentLevel)")
            }
            self.passwordAlert()
            
            
        } else{
            print("im passiong")
            let newView = self.storyboard?.instantiateViewController(withIdentifier: "MainClass") as! ViewController
            self.present(newView, animated: true, completion: nil)
        }
    }
    
    func passwordAlert(){
        
       
        //1. Create the alert controller.
        let alert = UIAlertController(title: "PASSWORD", message: "Enter the password", preferredStyle: .alert)
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
            textField.isSecureTextEntry = true
        }
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            //print("Text field: \(textField.text)")
            if(textField.text != self.pass){
                self.showToast(message: "Wrong Password")
                alert?.dismiss(animated: true, completion: nil)
                self.passwordAlert()
            }else if(textField.text == self.pass){
                self.showToast(message: "correct password")
                alert?.dismiss(animated: true, completion: nil)
                
                let newView = self.storyboard?.instantiateViewController(withIdentifier: "MainClass") as! ViewController
                self.present(newView, animated: true, completion: nil)
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { [weak alert] (_) in
            exit(0)
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func btnpass(_ sender: Any) {
        let newView = self.storyboard?.instantiateViewController(withIdentifier: "MainClass") as! ViewController
        self.present(newView, animated: true, completion: nil)
        
    }
    
}
