//
//  MapDelegate.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 01/01/2019.
//  Copyright © 2019 IF26. All rights reserved.
//
import GoogleMaps
import Foundation
protocol MapDelegate:class {
    func updateMap(location : CLLocation)
    
    func addDestination(name : String , lat : Double , long : Double )
}
