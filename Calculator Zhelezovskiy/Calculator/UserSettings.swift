//
//  UserSettings.swift
//  Calculator
//
//  Created by Михаил Железовский on 13.02.2022.
//

import Foundation

final class UserSettings {
    
    static var currentNumber : Double {
        get {
            return UserDefaults.standard.double(forKey: "currentNumber")
        } set {
            let defaults = UserDefaults.standard
            let key = "currentNumber"
            if  newValue != 0 {
                defaults.set(newValue, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
}
