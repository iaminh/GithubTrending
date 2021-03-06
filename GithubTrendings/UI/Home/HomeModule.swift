//
//  HomeModule.swift
//  TVShow
//
//  Created by Chu Anh Minh on 5/27/19.
//  Copyright © 2019 MinhChu. All rights reserved.
//

import UIKit

class HomeModule: Module {
    private let udManager = UDManager()

    private lazy var listModule: GithubListModule = {
        let navigationController =  UINavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "repositories".localized, image: #imageLiteral(resourceName: "db"), tag: 1)
        let router = Router(navigationController: navigationController)
        let module = GithubListModule(router: router, udManager: udManager)

        addChild(module)

        return module
    }()

    private lazy var favoritesModule: GithubFavoritesModule = {
        let navigationController =  UINavigationController()
        navigationController.tabBarItem = UITabBarItem(title: "favorites".localized, image: #imageLiteral(resourceName: "bookmark"), tag: 1)
        let router = Router(navigationController: navigationController)
        let module = GithubFavoritesModule(router: router, udManager: udManager)

        addChild(module)

        return module
    }()

    private let tabBarController: UITabBarController

    private var tabs: [UIViewController: Module] = [:]

    override func toPresentable() -> UIViewController {
        return tabBarController.toPresentable()
    }

    override init(router: Router) {
        self.tabBarController = UITabBarController()
        super.init(router: router)
        setTabs()
    }


    private func setTabs() {
        tabs = [:]

        let vcs = [listModule, favoritesModule].map { coordinator -> UIViewController in
            let viewController = coordinator.toPresentable()
            tabs[viewController] = coordinator
            return viewController
        }

        tabBarController.setViewControllers(vcs, animated: false)
    }
}
