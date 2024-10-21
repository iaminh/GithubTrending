//
//  GithubListVm.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import SwiftUI
import Combine

@MainActor
class GithubListViewModel: ObservableObject {
    private var dayRepos: [Repo] = [] {
        didSet {
            if selectedSegment == .day {
                repos = dayRepos.map { self.createCell(from: $0) }
            }
        }
    }
    
    private var weekRepos: [Repo] = [] {
        didSet {
            if selectedSegment == .week {
                repos = weekRepos.map { self.createCell(from: $0) }
            }
        }
    }
    
    private var monthRepos: [Repo] = [] {
        didSet {
            if selectedSegment == .month {
                repos = monthRepos.map { self.createCell(from: $0) }
            }
        }
    }

    @Published var selectedSegment: Interval = .day
    @Published var isLoading: Bool = false
    @Published var repos: [Cell] = []

    @Inject
    private var dataProvider: DataProvider

    @Inject
    private var bookmarkedRepository: BookmarkedRepository

    private var cancellables = Set<AnyCancellable>()

    init() {
        Task {
            await loadAllData()
        }

        $selectedSegment
            .sink { [weak self] interval in
                guard let self else { return }
                switch interval {
                case .day:
                    repos = dayRepos.map { self.createCell(from: $0) }
                case .week:
                    repos = weekRepos.map { self.createCell(from: $0) }
                case .month:
                    repos = monthRepos.map { self.createCell(from: $0) }
                }
            }.store(in: &cancellables)
    }

    private func createCell(from repo: Repo) -> Cell {
        Cell(
            repo: repo,
            bookmarked: bookmarkedRepository.repos.value.contains(repo),
            onTap: { [weak self] in
                guard let self else { return }
                if bookmarkedRepository.repos.value.contains(repo) {
                    bookmarkedRepository.remove(repo: repo)
                } else {
                    bookmarkedRepository.add(repo: repo)
                }
            }
        )
    }

    private func loadAllData() async {
        isLoading = true

        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.loadData(for: .day)
            }

            group.addTask {
                await self.loadData(for: .week)
            }

            group.addTask {
                await self.loadData(for: .month)
            }
        }

        isLoading = false
    }

    private func loadData(for interval: Interval) async {
        print("Loading data for interval \(interval)...")

        let page = getPage(for: interval)
        let newRepos = (try? await dataProvider.loadRepos(for: interval, page: page, perPage: 20)) ?? [] // TODO: Error handling

        updateRepos(for: interval, with: newRepos)
    }

    private func getPage(for interval: Interval) -> Int {
        switch interval {
        case .day: return dayRepos.count / 20
        case .week: return weekRepos.count / 20
        case .month: return monthRepos.count / 20
        }
    }

    private func updateRepos(for interval: Interval, with repos: [Repo]) {
        switch interval {
        case .day: dayRepos.append(contentsOf: repos)
        case .week: weekRepos.append(contentsOf: repos)
        case .month: monthRepos.append(contentsOf: repos)
        }
    }

    func loadMore() {
        Task {
            print("Loading more...")
            isLoading = true
            let interval = selectedSegment
            let page = getPage(for: interval)
            let newRepos = (try? await dataProvider.loadRepos(for: interval, page: page, perPage: 20)) ?? [] // TODO: Error handling

            updateRepos(for: interval, with: newRepos)
            isLoading = false
        }
    }
}

extension GithubListViewModel {
    struct Cell: Identifiable, Hashable {
        static func == (lhs: GithubListViewModel.Cell, rhs: GithubListViewModel.Cell) -> Bool {
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

        init(repo: Repo, bookmarked: Bool, onTap: @escaping () -> Void) {
            title = repo.owner.login + "/" + repo.name
            subtitle = repo.description
            self.bookmarked = bookmarked
            avatarUrl = repo.owner.avatarUrl
            self.onTap = onTap
        }
    }
}
