//
//  HomeView.swift
//  GithubTrendings
//
//  Created by Minh Chu on 18.10.2024.
//  Copyright © 2024 MinhChu. All rights reserved.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                GithubListScreen()
            }
            .tabItem {
                Label("Repositories", systemImage: "list.dash")
            }
            .tag(0)

            NavigationStack {
                GithubFavoritesScreen()
            }
            .tabItem {
                Label("Favorites", systemImage: "bookmark")
            }
            .tag(1)
        }
    }
}

#Preview {
    HomeView()
}
