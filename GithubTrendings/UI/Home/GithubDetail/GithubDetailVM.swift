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
        self.description = repo.description ?? NSLocalizedString("description_placeholder", comment: "")
        self.language = repo.language ?? NSLocalizedString("language_placeholder", comment: "")
        self.stars = String.localizedStringWithFormat(NSLocalizedString("stars_count", comment: ""), String(repo.stargazersCount))
        self.forks = String.localizedStringWithFormat(NSLocalizedString("forks_count", comment: ""), String(repo.forks))
        self.created = String.localizedStringWithFormat(NSLocalizedString("created_at", comment: ""), repo.createdAt.toDayString())
        self.openUrl = URL(string: repo.htmlUrl)
    }
}
