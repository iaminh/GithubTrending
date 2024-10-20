//
//  Route.swift
//  GithubTrendings
//
//  Created by Minh Chu on 18.10.2024.
//  Copyright © 2024 MinhChu. All rights reserved.
//

import Foundation

enum Route: Hashable {
    case favourites
    case detail(Repo)
}
