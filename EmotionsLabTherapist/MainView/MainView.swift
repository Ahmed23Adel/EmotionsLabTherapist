//
//  MainView.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 10/04/2025.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    
    // Add Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}

class ItemsViewModel: ObservableObject {
    @Published var items = [
        Item(title: "Patient 1", description: "Therapy sessions twice a week. Showing improvement in managing anxiety."),
        Item(title: "Patient 2", description: "New patient. Initial assessment completed. Treatment plan focuses on depression management."),
        Item(title: "Patient 3", description: "Working through trauma therapy. Progress is steady with occasional setbacks."),
        Item(title: "Patient 4", description: "Family therapy sessions. All members engaged and communicating more effectively."),
        Item(title: "Patient 5", description: "Cognitive behavioral therapy for phobias. Exposure therapy showing promising results.")
    ]
}


struct MainView: View {
    @StateObject private var viewModel = ItemsViewModel()
    @State private var selectedItem: Item?
    
    var body: some View {
        NavigationSplitView {
            // List on the left
            List(viewModel.items, selection: $selectedItem) { item in
                Text(item.title)
                    .tag(item)  // This is the key addition
            }
            .navigationTitle("Patients")
        } detail: {
            // Detail view on the right
            if let selectedItem = selectedItem {
                VStack(alignment: .leading, spacing: 20) {
                    Text(selectedItem.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(selectedItem.description)
                        .font(.body)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Patient Details")
            } else {
                Text("Select a patient to view details")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            // Force landscape orientation when view appears
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            
            // Set supported orientations to landscape only
            AppDelegate.orientationLock = .landscape
        }
        .navigationBarBackButtonHidden(true)
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
