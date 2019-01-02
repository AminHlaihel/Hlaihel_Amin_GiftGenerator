//
//  longlatname.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 02/01/2019.
//  Copyright © 2019 IF26. All rights reserved.
//

import Foundation
import GoogleMaps
public class LongLatName  {
    var nom: String
    var longlat : CLLocationCoordinate2D
    
    
    
    
    init(nom: String, longlat: CLLocationCoordinate2D) {
        self.nom = nom
        self.longlat = longlat
       
    }
}
