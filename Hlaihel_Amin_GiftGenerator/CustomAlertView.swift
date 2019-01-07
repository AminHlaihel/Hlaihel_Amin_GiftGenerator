//
//  CustomAlertView.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 03/01/2019.
//  Copyright © 2019 IF26. All rights reserved.
//

import UIKit

class CustomAlertView: UIViewController {

    
    
    @IBOutlet weak var titelField: UILabel!
    
    @IBOutlet weak var nameField: UILabel!
    
    @IBOutlet weak var prixField: UILabel!
    
    @IBOutlet weak var imageField: UIImageView!
    
    @IBOutlet weak var pickButton: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var alertView: UIView!
    
    var name : String = ""
    var prix : String = ""
    var titre : String = ""
    var imageindex : Int = 15
    
    var delegate: CustomAlertViewDelegate?
    
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }

    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.titelField.text = titre
        self.nameField.text = name
        self.prixField.text = prix
        if(imageindex < 14){
        self.imageField.image = UIImage(named: "gift_number_\(imageindex+1)")
        }
        
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    
    @IBAction func onPicktapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        delegate?.pickButtonTapped()
        
        
    }
    
    @IBAction func onRandomtapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.randomButtonTapped()
        
    }
    
    
    
    @IBAction func canceltapped(_ sender: Any) {
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
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
