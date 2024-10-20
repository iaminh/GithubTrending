//
//  GithubListVm.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import SwiftUI

@MainActor
class GithubListViewModel: ObservableObject {
    @Published var dayRepos: [Repo] = []
    @Published var weekRepos: [Repo] = []
    @Published var monthRepos: [Repo] = []

    @Published var selectedSegment: Interval = .day
    @Published var isLoading: Bool = false

    @Inject
    private var dataProvider: DataProvider

    @Inject
    private var bookmarkedRepository: BookmarkedRepository

    init() {
        loadData(for: .day)
        loadData(for: .week)
        loadData(for: .month)
    }

    func loadData(for interval: Interval) {
        Task {
            isLoading = true
            let page = getPage(for: interval)
            let newRepos = (try? await dataProvider.loadRepos(for: interval, page: page, perPage: 20)) ?? [] // TODO: Error handling

            updateRepos(for: interval, with: newRepos)
            isLoading = false
        }
    }

    func loadMore() {
        Task {
            isLoading = true
            let interval = selectedSegment
            let page = getPage(for: interval)
            let newRepos = (try? await dataProvider.loadRepos(for: interval, page: page, perPage: 20)) ?? [] // TODO: Error handling

            updateRepos(for: interval, with: newRepos)
            isLoading = false
        }
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
}
