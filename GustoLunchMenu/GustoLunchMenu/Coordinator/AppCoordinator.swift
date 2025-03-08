
import FirebaseAuth
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var lunchMenuViewModel: LunchMenuViewModel
    @Published var authViewModel: AuthViewModel

    init(service: LunchMenuService = LunchMenuDataSource()) {
        self.authViewModel = AuthViewModel()
        self.lunchMenuViewModel = LunchMenuViewModel(service: service)
        checkAuthStatus() // ✅ Check if user is already signed in
    }

    /// Checks Firebase auth to determine if user is signed in
    private func checkAuthStatus() {
        if Auth.auth().currentUser != nil {
            self.isAuthenticated = true
        }
    }

    func makeAuthenticationView() -> some View {
        AuthenticationView(authViewModel: authViewModel, onSignInComplete: {
            self.isAuthenticated = true
        })
    }

    func makeMainTabView() -> some View {
        MainTabView(viewModel: self.lunchMenuViewModel)
    }
}
