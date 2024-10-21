//
//  NetworkImage.swift
//  GithubTrendings
//
//  Created by Minh Chu on 21.10.2024.
//  Copyright © 2024 MinhChu. All rights reserved.
//

import SwiftUI

struct NetworkImage: View {
    let url: String

    @StateObject private var loader = Loader()

    var body: some View {
        ZStack {
            switch loader.state {
            case .loading:
                ProgressView()
            case .failure:
                Image(systemName: "exclamationmark.triangle")
            case .loaded(let img):
                Image(uiImage: img).resizable()
            }
        }
        .task {
            await loader.load(url: url)
        }
    }
}

extension NetworkImage {
    @MainActor
    class Loader: ObservableObject {
        enum LoadingState {
            case loading
            case loaded(UIImage)
            case failure(Error)
        }

        @Inject
        private var repository: ImageRepository

        @Published
        var state: LoadingState = .loading

        func load(url: String) async {
            guard let url = URL(string: url) else {
                log.message("Error Invalid url")
                state = .failure(ImageError.invalidUrl)
                return
            }

            do {
                let image = try await repository.image(for: url)
                state = .loaded(image)
            } catch {
                log.message("Error: \(error)")
                state = .failure(error)
            }
        }
    }
}
