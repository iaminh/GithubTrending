//
//  File.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import Foundation

struct Repo: Codable, Hashable, Identifiable {
    struct User: Codable, Hashable {
        let avatarUrl: String
        let login: String
    }

    let name: String
    let owner: User
    let description: String?
    let forks: Int
    let stargazersCount: Int
    let language: String?
    let createdAt: Date
    let htmlUrl: String
    
    var id: String {
        return name
    }
}

struct GithubResponseDTO: Codable {
    let items: [Repo]
}

enum Interval: String, CaseIterable {
    case day
    case week
    case month

    func toDate() -> Date {
        switch self {
        case .month:
            return Calendar.current.date(byAdding: DateComponents(month: -1), to: Date())!
        case .day:
            return Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())!
        case .week:
            return Calendar.current.date(byAdding: DateComponents(weekOfYear: -1), to: Date())!
        }
    }

    var localizedTitle: String {
        return ("last_" + self.rawValue).localized
    }
}

protocol DataProvider {
    func loadRepos(for interval: Interval, page: Int, perPage: Int) async throws -> [Repo]
}

struct DataProviderImp: DataProvider, Dependency {
    private func createRequest(for interval: Interval, page: Int, perPage: Int) -> URLRequest {
        let baseURL = URL(string: "https://api.github.com/search/repositories")!
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!

        components.queryItems = [
            .init(name: "q", value: "q"),
            .init(name: "order", value: "desc"),
            .init(name: "sort", value: "stars"),
            .init(name: "per_page", value: String(perPage)),
            .init(name: "page", value: String(page)),
            .init(name: "created", value: interval.toDate().toDayString()),
        ]

        return URLRequest(url: components.url!)
    }

    func loadRepos(for interval: Interval, page: Int, perPage: Int) async throws -> [Repo] {
        let request = createRequest(for: interval, page: page, perPage: perPage)

        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedResponse = try CustomDecoder().decode(GithubResponseDTO.self, from: data)
        return decodedResponse.items.shuffled() // we randomize for testing purposes
    }
}
