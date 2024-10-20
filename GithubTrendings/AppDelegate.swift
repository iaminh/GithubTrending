//
//  AppDelegate.swift
//  GithubTrendings
//
//  Created by Minh Chu on 20.10.2024.
//  Copyright © 2024 MinhChu. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerDependencies()

        return true
    }
    private func registerDependencies() {
        let container = DependencyContainerImp.shared
        container.register(instance: DataProviderImp(), scope: .global, key: String(describing: DataProvider.self))
        container.register(instance: BookmarkedRepositoryImp(), scope: .global, key: String(describing: BookmarkedRepository.self))
        container.register(instance: ImageRepositoryImp(), scope: .global, key: String(describing: ImageRepository.self))
        container.register(instance: AppRouter(), scope: .global)
    }

}
