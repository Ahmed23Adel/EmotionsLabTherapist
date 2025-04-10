//
//  AppResetDetector.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 09/04/2025.
//

import Foundation

struct AppResetDetector{
    private init() {}
    static let hasLaunchedBeforeKey = "hasLaunchedBefore"
    
    static func clearKeychainIfFirstLaunch(){
        let hasLaunchedBeforeValue = UserDefaults.standard.bool(forKey: hasLaunchedBeforeKey)
        if !hasLaunchedBeforeValue{
            UserDefaults.standard.set(true, forKey: hasLaunchedBeforeKey)
            UserDefaults.standard.synchronize()
            KeychainHelper.shared.clearAll()
            print("clearKeychainIfFirstLaunch Done")
        }
    }
}
