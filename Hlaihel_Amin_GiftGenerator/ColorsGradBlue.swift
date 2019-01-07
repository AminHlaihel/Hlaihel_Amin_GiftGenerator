//
//  ColorsGradBlue.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 07/01/2019.
//  Copyright © 2019 IF26. All rights reserved.
//

import Foundation
import UIKit

class ColorsBlue {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: 163.0 / 255.0, green: 228.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 84.0 / 255.0, green: 153.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}
