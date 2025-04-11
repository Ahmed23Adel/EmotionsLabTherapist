//
//  SignUpView.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 10/04/2025.
//

import AuthenticationServices
import SwiftUI

struct SignUpView: View {
    @StateObject private var signupViewModel = SignupViewModel()
    @State private var alexFloating = false
    @State private var isNavigateToMainViewLocal = false
    
    var body: some View {
        NavigationStack {  // Add this NavigationStack
            VStack {
                ZStack {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image("alex")
                                .padding(.leading, 150)
                                .offset(y: alexFloating ? -10 : 10)
                                .animation(
                                    Animation.easeInOut(duration: 1.2)
                                        .repeatForever(autoreverses: true),
                                    value: alexFloating
                                )
                                .onAppear {
                                    alexFloating.toggle()
                                }
                        }
                    }
                    VStack {
                        VStack {
                            VStack(spacing: 10) {
                                Text("Emotions Lab")
                                    .font(.system(size: 80))
                                
                                Text("Therapist version")
                                    .font(.system(size: 48))
                            }
                            .padding(.top, 60)
                            .padding(.bottom, 60)
                            
                            SignInWithAppleButton(
                                .signUp,
                                onRequest: signupViewModel.configureRequest,
                                onCompletion: signupViewModel.handleAuthorization
                            )
                            .frame(width: 150, height: 40)
                            .signInWithAppleButtonStyle(.black)
                            .cornerRadius(10)
                            .padding(.top, 60)
                            
                            Spacer(minLength: 100)
                        }
                    }
                    if signupViewModel.isClickedOnSignUpButton {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .blur(radius: 10)
                        
                        ProgressView("Please wait ...")
                    }
                }
                .navigationBarBackButtonHidden(true)
                .background(Color(red: 245/255, green: 238/255, blue: 220/255))  // Fixed color values
                .alert(isPresented: $signupViewModel.isSignUpFailed) {
                    Alert(
                        title: Text(signupViewModel.signUpErrorTitle),
                        message: Text(signupViewModel.signUpErrorMsg),
                        dismissButton: .default(Text("Ok"))
                    )
                }
            }
            .navigationDestination(isPresented: $isNavigateToMainViewLocal) {
                MainView()
            }
            .onAppear {
                // Add debug print
                print("SignUpView appeared, isNavigateToMainView: \(signupViewModel.isNavigateToMainView)")
            }
            .onChange(of: signupViewModel.isNavigateToMainView) { newValue in
                print("isNavigateToMainView changed to: \(newValue)")
                if newValue {
                    print("Setting isNavigateToMainViewLocal to true")
                    isNavigateToMainViewLocal = true
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
