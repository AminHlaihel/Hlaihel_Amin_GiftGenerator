//
//  AjoutGiftViewController.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 29/12/2018.
//  Copyright © 2018 IF26. All rights reserved.
//

import UIKit

class AjoutGiftViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func radioFood(_ sender: Any) {
        label.text = "Food"
    }
    
    
    @IBAction func radioJewlery(_ sender: Any) {
        label.text="Jewlery"
    }
    
    
    @IBAction func radioType(_ sender: Any) {
        label.text = "Type"
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
