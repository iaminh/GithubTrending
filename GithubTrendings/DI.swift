//
//  DI.swift
//  GithubTrendings
//
//  Created by Minh Chu on 18.10.2024.
//  Copyright © 2024 MinhChu. All rights reserved.
//

import Foundation

protocol Dependency { }

enum ResolutionScope {
    case global
    case local
    case custom(String)  // Allows for named instances
}

protocol DependencyContainer {
    func resolve<T>(type: T.Type, key: String?) -> T
}

extension DependencyContainer {
    static func resolve<T>(key: String? = nil) -> T {
        DependencyContainerImp.shared.resolve(type: T.self, key: key)
    }
}

@propertyWrapper
struct Inject<Value> {
    private let key: String?
    private let scope: ResolutionScope

    init(key: String? = nil, scope: ResolutionScope = .global) {
        self.key = key
        self.scope = scope
    }

    var wrappedValue: Value {
        return DependencyContainerImp.shared.resolve(type: Value.self, key: key)
    }
}

final class DependencyContainerImp: DependencyContainer {
    static var shared: DependencyContainerImp = DependencyContainerImp()

    private var registry = [String: Dependency]()
    private var transientRegistry = [String: () -> Dependency]()

    func register<T: Dependency>(instance: @autoclosure @escaping () -> T, scope: ResolutionScope, key: String = String(describing: T.self)) {
        switch scope {
        case .global:
            registry[key] = instance()
        case .local:
            transientRegistry[key] = instance
        case .custom(let customKey):
            registry[customKey] = instance()
        }
    }

    func resolve<T>(type: T.Type, key: String? = String(describing: T.self)) -> T {
        let resolvedKey = key ?? String(describing: T.self)
        if let instance = registry[resolvedKey] as? T {
            return instance
        } else if let factory = transientRegistry[resolvedKey] {
            return factory() as! T
        }

        fatalError("Could not resolve dependency for \(resolvedKey)")
    }
}
