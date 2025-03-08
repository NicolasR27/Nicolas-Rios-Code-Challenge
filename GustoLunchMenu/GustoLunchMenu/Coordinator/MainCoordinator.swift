//
//  MainCoordinator.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import Foundation
import SwiftUI

protocol Coordinator: ObservableObject {
    associatedtype RootView: View
    func start() -> RootView
}

/// Main Coordinator responsible for navigation flow.
final class MainCoordinator: ObservableObject {
    @Published var viewModel: LunchMenuViewModel

    init(viewModel: LunchMenuViewModel) {
        self.viewModel = viewModel
    }

    func makeMainTabView() -> some View {
        MainTabView(viewModel: self.viewModel)
    }
}
