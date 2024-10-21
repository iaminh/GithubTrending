//
//  GithubFavoritesVM.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import SwiftUI
import Combine

@MainActor
class GithubFavoritesViewModel: ObservableObject {
    @Published var cells: [Cell] = []
    @Published var selectedRepo: Repo?

    @Inject
    private var repository: BookmarkedRepository

    private var cancellables = Set<AnyCancellable>()
    init() {
        Task {
            await observeSavedRepos()
        }
    }

    private func observeSavedRepos() async {
        repository.repos.sink { [weak self] repos in
            self?.cells = repos.map { repo in
                Cell(
                    title: "\(repo.owner.login)/\(repo.name)",
                    subtitle: repo.description,
                    bookmarked: true,
                    avatarUrl: repo.owner.avatarUrl,
                    onTap: { [weak self] in self?.removeFavourite(for: repo) }
                )
            }
        }.store(in: &cancellables)
    }

    func removeFavourite(for repo: Repo) {
        repository.remove(repo: repo)
    }
}

extension GithubFavoritesViewModel {
    struct Cell: Identifiable, Hashable {
        static func == (lhs: GithubFavoritesViewModel.Cell, rhs: GithubFavoritesViewModel.Cell) -> Bool {
            return lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        let id = UUID()
        let title: String
        let subtitle: String?
        let bookmarked: Bool
        let avatarUrl: String

        let onTap: () -> Void
    }
}
