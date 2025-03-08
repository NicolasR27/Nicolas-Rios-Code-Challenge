//
//  AuthModel.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import CryptoKit
import AuthenticationServices

/// Handles Firebase Authentication for Apple Sign In
@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    private var currentNonce: String?

    /// Check if user is already signed in
    func checkAuthentication() {
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
        }
    }

    /// Handles Firebase authentication with Apple Sign-In
    func signInWithApple(authorization: ASAuthorization) async throws {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            throw NSError(domain: "AppleIDError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get Apple ID credentials."])
        }

        guard let identityToken = appleIDCredential.identityToken else {
            throw NSError(domain: "AppleIDError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve identity token."])
        }

        guard let tokenString = String(data: identityToken, encoding: .utf8) else {
            throw NSError(domain: "AppleIDError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode identity token."])
        }

        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: tokenString,
            rawNonce: currentNonce ?? ""
        )

        let authResult = try await Auth.auth().signIn(with: credential)
        isAuthenticated = authResult.user != nil
    }

    /// Generates a random cryptographic nonce for Apple Sign-In
    func generateNonce() -> String {
        let nonce = randomNonceString()
        currentNonce = nonce
        return sha256(nonce)
    }

    private func randomNonceString(length: Int = 32) -> String {
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
        return String((0..<length).map { _ in charset.randomElement()! })
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}
