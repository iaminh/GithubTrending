//
//  UDManager.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import Combine
import SwiftUI

@propertyWrapper
struct UserDefaultCodable<Value: Codable> {
    let key: String
    let defaultValue: Value

    var wrappedValue: Value {
        get {
            if let data = UserDefaults.standard.data(forKey: key),
               let decodedValue = try? JSONDecoder().decode(Value.self, from: data) {
                return decodedValue
            }
            return defaultValue
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: key)
            }
        }
    }
}


protocol BookmarkedRepository {
    var repos: CurrentValueSubject<Set<Repo>, Never> { get }

    func remove(repo: Repo)
    func add(repo: Repo)
}

class BookmarkedRepositoryImp: BookmarkedRepository, Dependency {
    // Using the custom UserDefaultCodable property wrapper
    @UserDefaultCodable(key: "bookmarked", defaultValue: Set<Repo>())
    private var storedRepos: Set<Repo>

    // Use a CurrentValueSubject to hold the current repos state and publish changes
    var repos: CurrentValueSubject<Set<Repo>, Never>

    private var cancellables = Set<AnyCancellable>()

    init() {
        repos = .init(.init())
        repos.send(storedRepos)
        repos
            .sink { updatedRepos in
                self.storedRepos = updatedRepos // This will automatically update UserDefaults
            }
            .store(in: &cancellables)

    }

    func remove(repo: Repo) {
        var updatedRepos = repos.value
        updatedRepos.remove(repo)
        repos.send(updatedRepos) // Notify subscribers about the change
    }

    func add(repo: Repo) {
        var updatedRepos = repos.value
        updatedRepos.insert(repo)
        repos.send(updatedRepos) // Notify subscribers about the change
    }
}

