//
//  GithubTrendingsApp.swift
//  GithubTrendings
//
//  Created by Minh Chu on 18.10.2024.
//  Copyright © 2024 MinhChu. All rights reserved.
//

import SwiftUI

class AppRouter: ObservableObject, Dependency {
    @Published var routes: [Route] = []

    func pop() {
        routes.removeLast()
    }

    func popToRoot() {
        routes.removeAll()
    }

    func push(route: Route) {
        routes.append(route)
    }
}

@main
struct GithubTrendingsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var router: AppRouter = DependencyContainerImp.shared.resolve(type: AppRouter.self, key: nil)

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.routes) {
                HomeScreen()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .favourites:
                            GithubFavoritesScreen()
                        case .detail(let repo):
                            GithubDetailScreen(viewModel: .init(repo: repo))
                        }
                    }
            }
        }
    }
}
