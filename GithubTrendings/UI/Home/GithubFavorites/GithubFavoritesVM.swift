//
//  GithubFavoritesVM.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import SwiftUI

class GithubFavoritesViewModel: ObservableObject {
    @Published var cells: [Cell] = []
    @Published var selectedRepo: Repo?

    @Inject
    private var repository: BookmarkedRepository

    init() {
        Task {
            await observeSavedRepos()
        }
    }

    private func observeSavedRepos() async {
        for await repos in repository.bookmarkedReposStream {
            self.cells = repos.map { repo in
                Cell(
                    title: "\(repo.owner.login)/\(repo.name)",
                    subtitle: repo.description,
                    bookmarked: true,
                    avatarUrl: repo.owner.avatarUrl
                )
            }
        }
    }

    func selectRepo(at index: Int) {
//        guard index < cells.count else { return }
//        selectedRepo = Array(udManager.reposRelay.value)[index]
    }

    func toggleBookmark(for repo: Repo) {

    }
}

extension GithubFavoritesViewModel {
    struct Cell: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let subtitle: String?
        let bookmarked: Bool
        let avatarUrl: String
    }
}
