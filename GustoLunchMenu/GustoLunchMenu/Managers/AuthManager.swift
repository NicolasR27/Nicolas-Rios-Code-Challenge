//
//  AuthManager.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import Foundation
import CryptoKit
import AuthenticationServices
import FirebaseAuth

/// Handles Firebase Authentication for Apple Sign In
final class AuthManager {
    static let shared = AuthManager()
    private init() {}

    /// Stores current nonce for authentication
    private var currentNonce: String?

    /// Generates a cryptographic nonce for secure authentication
    func generateNonce() -> String {
        let nonce = randomNonceString()
        currentNonce = nonce
        return sha256(nonce)
    }

    /// Signs in with Apple credentials
    func signInWithApple(authorization: ASAuthorization) async throws {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = appleIDCredential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8),
              let nonce = currentNonce else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Apple ID credentials"])
        }

        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        try await Auth.auth().signIn(with: credential)
    }

    // MARK: - Private Helpers

    /// Generates a secure random nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms = (0..<16).map { _ in UInt8.random(in: 0...255) }
            for random in randoms {
                if remainingLength == 0 {
                    break
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    /// Creates a SHA256 hash
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}
