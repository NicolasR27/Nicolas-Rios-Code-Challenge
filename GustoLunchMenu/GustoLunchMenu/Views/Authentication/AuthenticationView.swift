//
//  AuthenticationView.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import SwiftUI

struct AuthenticationView: View {
    let authViewModel: AuthViewModel
    let onSignInComplete: () -> Void 

    var body: some View {
        VStack {
            SignInWithAppleView(authViewModel: authViewModel, onSignInComplete: onSignInComplete)
        }
    }
}
