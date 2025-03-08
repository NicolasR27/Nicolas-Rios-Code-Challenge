//
//  MainTabView.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel: LunchMenuViewModel

    var body: some View {
        TabView {
            NavigationStack { 
                LunchCalendarView(viewModel: viewModel)
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }

            }
        }
    }

