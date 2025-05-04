//
//  SignUpViewModel.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 10/04/2025.
//

import Foundation
import AuthenticationServices

@MainActor
class SignupViewModel: ObservableObject{
    @Published var isClickedOnSignUpButton: Bool = false
    @Published var hasUserSignedUp: Bool = false
    private let therapsit = Therapist.shared
    @Published var isSignUpFailed = false
    @Published private(set) var signUpErrorMsg = ""
    @Published private(set) var signUpErrorTitle = ""
    @Published private (set) var isNavigateToMainView = false
    
    func configureRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    func handleAuthorization(_ result: Result<ASAuthorization, Error>) {
        Task {
            DispatchQueue.main.async{
                self.isClickedOnSignUpButton = true
            }
            await tempHandleAuthorization()
        }
        return
    }

    func tempHandleAuthorization() async {
        let appleId = "jkfda8104"
        let fullName = "ahmed adel"
        let email = "ahmed9884@gmail.com"
        Task{
            let therapistId = await therapsit.signupAndExtractTherapistId(appleId: appleId, fullName: fullName, email: email)
            print("therapistId", therapistId)
            therapsit.saveTherapistId(therapistId: therapistId)
            if await therapsit.authAccess.loginUsingAppleAuth(appleId: appleId){
                print("u1")
                DispatchQueue.main.async {
                    print("u2")
                    self.isClickedOnSignUpButton = false
                    self.hasUserSignedUp = false
                    self.isNavigateToMainView = true
                }
                
            } else{
                isSignUpFailed = false
                signUpErrorMsg = "Please try again later"
                signUpErrorTitle = "Signup Failed"
            }
            
        }
        
        
        
        
        
    }
}
