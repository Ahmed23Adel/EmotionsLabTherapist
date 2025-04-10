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
    @State private var floating = false

    var body: some View {

        VStack {
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("alex")
                            .padding(.leading, 150)
                            .offset(y: floating ? -10 : 10)  // moves up & down
                            .animation(
                                Animation.easeInOut(duration: 1.2)
                                    .repeatForever(autoreverses: true),
                                value: floating
                            )
                            .onAppear {
                                floating.toggle()
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
            }
            .navigationBarBackButtonHidden(true)
            .background(Color(red: 245, green: 238, blue: 220))

        }
    }
}

#Preview {
    SignUpView()
}
