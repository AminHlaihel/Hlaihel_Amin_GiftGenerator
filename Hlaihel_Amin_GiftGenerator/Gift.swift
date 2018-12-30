//
//  Gift.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 30/12/2018.
//  Copyright © 2018 IF26. All rights reserved.
//

import Foundation

public class Gift  {
    var nom: String
    var category: String
    var prix: Int
    var type: String
    
    init() {
        nom = "?"
        category = "?"
        prix = 0
        type = "?"
    }
    
    init(nom: String, category: String, prix: Int, type: String) {
        self.nom = nom
        self.category = category
        self.prix = prix
        self.type = type
    }
    
    public var descriptor: String {
        return "Gift(\(nom),\(category),\(prix),\(type))"
    }
}
