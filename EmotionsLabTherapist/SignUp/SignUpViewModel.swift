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
    
    func configureRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    func handleAuthorization(_ result: Result<ASAuthorization, Error>) {
        Task {
            DispatchQueue.main.async{
                self.isClickedOnSignUpButton = true
            }
            await tempHandleAuthorization()
            DispatchQueue.main.async{
                self.isClickedOnSignUpButton = false
            }
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
        
        
    }
}
