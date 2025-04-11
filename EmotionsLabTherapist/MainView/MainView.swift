//
//  MainView.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 10/04/2025.
//

import SwiftUI


struct MainView: View {
    @StateObject var mainViewModel = MainViewModel()
    var body: some View {
        NavigationSplitView {
            ZStack {
                // Background color for the entire view
                Color(red: 194/255, green: 179/255, blue: 140/255)
                    .ignoresSafeArea()
                
                VStack {
                    List(0..<5) { item in
                        Text("item \(item)")
                            .tag(item)
                    }
                    .scrollContentBackground(.hidden) // Hides the default list background
                    .background(Color(red: 194/255, green: 179/255, blue: 140/255))
                    
                    
                    Button(action: {
                        mainViewModel.showAddNewPatientSheet()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                            Text("Add new patient")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .background(Color(red: 194/255, green: 179/255, blue: 140/255)) // Set button background
                }
            }
            .navigationTitle("Patients")
        } detail: {
            Color(red: 245/255, green: 238/255, blue: 220/255)
                .ignoresSafeArea()
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .landscape
        }
        
        
        
    }
}

// App Delegate to handle orientation locking
class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

#Preview {
    MainView()
}
