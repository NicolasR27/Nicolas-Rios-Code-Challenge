//
//  SignInWithAppleView.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: View {
    @StateObject var authViewModel: AuthViewModel
    @State private var errorMessage: String?
    let onSignInComplete: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.teal.opacity(0.8), Color.teal.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                Text("Sign in with Apple")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 3)
                
                Spacer()
                
                SignInWithAppleButton(.signIn, onRequest: { request in
                    let nonce = authViewModel.generateNonce()
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = nonce
                }, onCompletion: handleSignInCompletion)
                .frame(height: 50)
                .frame(maxWidth: 280)
                .signInWithAppleButtonStyle(.black)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func handleSignInCompletion(result: Result<ASAuthorization, Error>) {
        switch result {
            case .success(let authResults):
                Task {
                    do {
                        try await authViewModel.signInWithApple(authorization: authResults)
                        DispatchQueue.main.async {
                            onSignInComplete()
                        }
                    } catch {
                        DispatchQueue.main.async {
                            errorMessage = "Error signing in: \(error.localizedDescription)"
                        }
                    }
                }
            case .failure(let error):
                errorMessage = "Error signing in with Apple: \(error.localizedDescription)"
        }
    }
}
