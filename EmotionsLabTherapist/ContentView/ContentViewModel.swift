//
//  ContentViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 10/04/2025.
//

import Foundation

@MainActor
class ContentViewModel: ObservableObject{
    private let therapist = Therapist.shared
    @Published var userNeedsToSignUp: Bool = false
    @Published var isChecking: Bool = true
    
    init() {
        Task {
            await checkIsSignedIn()
            DispatchQueue.main.async {
                self.isChecking = false
            }
        }
    }

    
    func checkIsSignedIn() async{
        if checkIsAbleToContinueSession(){
            print("a1")
            if await checkIsAbleToContinueSessionWithExistingAccessToken(){
                print("a2")
                userNeedsToSignUp = false
                therapist.loadTherapistData()
            } else{
                print("a3")
                // some time refresh coulld fail if it's expired
                if await therapist.authAccess.refreshToken(){
                    print("a4")
                    userNeedsToSignUp = false
                    therapist.loadTherapistData()
                } else{
                    print("a5")
                    let (isSuccess, appleId) = therapist.tryReadAppleId()
                    if isSuccess {
                        print("a6")
                        if let appleId = appleId{
                            print("a7")
                            if await therapist.authAccess.loginUsingAppleAuth(appleId: appleId){
                                print("a8")
                                userNeedsToSignUp = false
                                therapist.loadTherapistData()
                            } else{
                                print("a9")
                                userNeedsToSignUp = true
                            }
                            
                        }
                    } else{
                        print("a11")
                        userNeedsToSignUp = true
                    }
                    
                }
            }
        } else{
            // sign up
            DispatchQueue.main.async {
                self.userNeedsToSignUp = true
            }
        }
    }
    private func checkIsAbleToContinueSession() -> Bool{
        therapist.authAccess.tryReadRefreshTokenFromKeyChainAndValidate()
    }
    
    private func checkIsAbleToContinueSessionWithExistingAccessToken() async -> Bool{
        return await therapist.authAccess.tryReadAccessTokenFromKeyChainAndValidate()
    }
}
