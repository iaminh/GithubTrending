//
//  UDManager.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import SwiftUI


protocol BookmarkedRepository {
    var bookmarkedReposStream: AsyncStream<Set<Repo>> { get }
}

class BookmarkedRepositoryImp: BookmarkedRepository, Dependency {
    @AppStorage("bookmarked") private var reposData: Data = UserDefaults.standard.data(forKey: "bookmarked") ?? Data()

    private var repos: Set<Repo> {
        get {
            guard let repoArray = try? JSONDecoder().decode([Repo].self, from: reposData) else { return [] }
            return Set(repoArray)
        }
        set {
            reposData = (try? JSONEncoder().encode(Array(newValue))) ?? Data()
        }
    }

    // An async stream that will provide updates
    private lazy var bookmarkChangesStream = AsyncStream<Set<Repo>> { continuation in
        continuation.yield(repos)

        let observer = NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            continuation.yield(self.repos)
        }

        continuation.onTermination = { _ in
            NotificationCenter.default.removeObserver(observer)
        }
    }

    // Async stream publisher for updates
    var bookmarkedReposStream: AsyncStream<Set<Repo>> {
        return bookmarkChangesStream
    }

}
