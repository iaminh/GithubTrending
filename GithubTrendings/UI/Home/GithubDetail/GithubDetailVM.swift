//
//  GithubDetailVM.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import SwiftUI

class GithubDetailViewModel: ObservableObject {
    let title: String
    let description: String
    let language: String
    let stars: String
    let forks: String
    let created: String
    let openUrl: URL?

    private let repo: Repo

    init(repo: Repo) {
        self.repo = repo
        self.title = "\(repo.owner.login)/\(repo.name)"
        self.description = repo.description ?? "description_placeholder".localized
        self.language = repo.language ?? "language_placeholder".localized
        self.stars = "stars_count".localized + " " + String(repo.stargazersCount)
        self.forks = "forks_count".localized + " " + String(repo.forks)
        self.created = "created_at".localized + " " + repo.createdAt.toDayString()
        self.openUrl = URL(string: repo.htmlUrl)
    }
}
