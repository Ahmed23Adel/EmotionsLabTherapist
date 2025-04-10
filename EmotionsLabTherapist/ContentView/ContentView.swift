//
//  ContentView.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 09/04/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        Group{
            if contentViewModel.isChecking{
                ProgressView("Checking")
            }else{
                if contentViewModel.userNeedsToSignUp{
                    SignUpView()
                } else{
                    MainView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
