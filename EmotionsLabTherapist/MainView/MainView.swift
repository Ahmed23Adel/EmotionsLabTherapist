//
//  MainView.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 10/04/2025.
//

import SwiftUI


struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    var body: some View {
        NavigationSplitView {
            ZStack {
                Color(red: 194/255, green: 179/255, blue: 140/255)
                    .ignoresSafeArea()
                
                VStack {
                    if viewModel.isLoadingAllPatients{
                        ProgressView("Please wait...")
                    } else{
                        List(viewModel.listOfPatients, id: \.patientId, selection: $viewModel.selectedPatient) { patient in
                            HStack{
                                Text("\(patient.firstName) \(patient.lastName)")
                                    
                                Spacer()
                                if patient.hasUnfinishedSessionYesterday{
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 8, height: 8)
                                }
                            }
                            .tag(patient)
                        }
                        .scrollContentBackground(.hidden) 
                        .background(Color(red: 194/255, green: 179/255, blue: 140/255))
                    }
                    
                    
                    
                    Button(action: {
                        viewModel.showAddNewPatientSheet()
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
            if let selectedPatient = viewModel.selectedPatient{
                ZStack {
                    VStack{
                        HStack{
                            Spacer()
                            Button{
                                viewModel.showSchedulePeriod()
                            } label: {
                                Image(systemName: "plus")
                            }
                            .padding(.trailing, 20)
                        }
                        TabView{
                            LastFinishedPeriodView(patient: selectedPatient)
                                .tabItem{
                                    Label("Last Finished item", systemImage: "clock.arrow.circlepath")
                                }
                            AllPeriodsView(patient: selectedPatient)
                                .tabItem {
                                    Label("All Periods", systemImage: "calendar")
                                }
                        }
                        
                    }
                    
                }
                .id(selectedPatient.patientId)
                
            } else{
                Color(red: 245/255, green: 238/255, blue: 220/255)
                    .ignoresSafeArea()
                    .overlay(
                        Text("Pleaes select a patient for more details")
                            .font(.title)
                            .foregroundColor(.gray)
                    )
            }
            
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .landscape
        }
        .sheet(isPresented: $viewModel.isShowAddNewPatientSheet){
            
            AddNewPatient(patient: viewModel.newCreatedPatient, onPatientAddedFun: viewModel.appendPatient)
        }
        .sheet(isPresented: $viewModel.isShowSchedulePeriodSheet){
            
            ScheduleNewPeriodAndSessionHolder(patient: viewModel.selectedPatient ?? Patient())
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
