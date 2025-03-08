//
//  GustoLunchMenuApp.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import SwiftUI
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct GustoLunchMenuApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if appCoordinator.isAuthenticated {
                    appCoordinator.makeMainTabView() // ✅ Auto-login if authenticated
                } else {
                    appCoordinator.makeAuthenticationView()
                }
            }
        }
    }
}
