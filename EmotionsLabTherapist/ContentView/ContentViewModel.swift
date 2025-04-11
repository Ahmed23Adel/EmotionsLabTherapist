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
            if checkIsAbleToContinueSessionWithExistingAccessToken(){
                userNeedsToSignUp = false
            } else{
                // some time refresh coulld fail if it's expired
                if await therapist.authAccess.refreshToken(){
                    userNeedsToSignUp = false
                } else{
                    let (isSuccess, appleId) = therapist.tryReadAppleId()
                    if isSuccess {
                        if let appleId = appleId{
                            if await therapist.authAccess.loginUsingAppleAuth(appleId: appleId){
                                userNeedsToSignUp = false
                            } else{
                                userNeedsToSignUp = true
                            }
                            
                        }
                    } else{
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
    
    private func checkIsAbleToContinueSessionWithExistingAccessToken() -> Bool{
        therapist.authAccess.tryReadAccessTokenFromKeyChainAndValidate()
    }
}
