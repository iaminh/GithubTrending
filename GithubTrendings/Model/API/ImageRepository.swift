//
//  ImageRepository.swift
//  GithubTrendings
//
//  Created by Minh Chu on 20.10.2024.
//  Copyright © 2024 MinhChu. All rights reserved.
//

import SwiftUI

// MARK: - ImageRepository Protocol
protocol ImageRepository {
    func image(for url: URL) async throws -> UIImage
}

enum ImageError: Error {
    case invalidResponse
    case invalidData
    case invalidUrl
}

// MARK: - ImageRepository Implementation
actor ImageRepositoryImp: ImageRepository, Dependency {
    private var cache: [URL: UIImage] = [:]

    func image(for url: URL) async throws -> UIImage {
        if let cachedImage = cache[url] {
            return cachedImage
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ImageError.invalidResponse
        }

        guard let image = UIImage(data: data) else {
            throw ImageError.invalidData
        }

        cache[url] = image

        return image
    }
}
