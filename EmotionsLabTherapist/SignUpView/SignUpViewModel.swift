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
                print("isClickedOnSignUpButton", self.isClickedOnSignUpButton)
            }
            await tempHandleAuthorization()
        }
        return
        // TODO uncomment when you have paid apple account
//        switch result {
//        case .success(let auth):
//            if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
//                let userID = appleIDCredential.user
//                let fullName = appleIDCredential.fullName
//                let email = appleIDCredential.email
//
//                print("Apple ID: \(userID)")
//                print("Full name: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
//                print("Email: \(email ?? "")")
//            }
//        case .failure(let error):
//            signUpErrorMsg = "Sign in failed \(error), please try again later"
//            signUpErrorTitle = "Sign up failed"
//            isSignUpFailed = true
//        }
    }

    func tempHandleAuthorization() async {
        let userID = "jkfda8104"
        let fullName = "ahmed adel"
        let email = "ahmed9884@gmail.com"
        Task{
            await therapsit.signup(userID: userID, fullName: fullName, email: email)
            if await therapsit.authAccess.loginUsingAppleAuth(userID: userID){
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
