//
//  EmotionsLabTherapistApp.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 09/04/2025.
//

import SwiftUI

@main
struct EmotionsLabTherapistApp: App {
    init(){
        AppResetDetector.clearKeychainIfFirstLaunch()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
