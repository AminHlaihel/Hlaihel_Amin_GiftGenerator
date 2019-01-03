//
//  FirstLaunch.swift
//  Hlaihel_Amin_GiftGenerator
//
//  Created by Amin Hlaihel on 02/01/2019.
//  Copyright © 2019 IF26. All rights reserved.
//

import Foundation
final class FirstLaunch {
    
    let userDefaults: UserDefaults = .standard
    
    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }
    
    init() {
        let key = "com.any-suggestion.FirstLaunch.WasLaunchedBefore"
        let wasLaunchedBefore = userDefaults.bool(forKey: key)
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            userDefaults.set(true, forKey: key)
        }
    }
    
}
