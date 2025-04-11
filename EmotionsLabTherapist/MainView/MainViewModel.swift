//
//  MainViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 10/04/2025.
//

import Foundation

class MainViewModel: ObservableObject{
    @Published private var isShowAddNewPatientSheet = false
    
    
    func showAddNewPatientSheet(){
        self.isShowAddNewPatientSheet = true
    }
}
