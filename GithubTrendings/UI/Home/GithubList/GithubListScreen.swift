//
//  GithubListVC.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import SwiftUI

struct GithubListScreen: View {
    @StateObject private var viewModel = GithubListViewModel()

    var body: some View {
        VStack {
            Picker("Interval", selection: $viewModel.selectedSegment) {
                ForEach(Interval.allCases, id: \.self) { interval in
                    Text(interval.localizedTitle).tag(interval)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            List {
                ForEach(viewModel.repos) { repo in
                    cell(repo: repo, isLast: repo == viewModel.repos.last)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("Repositories")
    }

    private func cell(repo: GithubListViewModel.Cell, isLast: Bool) -> some View {
        HStack {
            NetworkImage(url: repo.avatarUrl)
                .frame(width: 50, height: 50)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(repo.title)
                    .font(.headline)
                if let description = repo.subtitle {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            // Trigger loading more data when the last item appears
            if isLast && !viewModel.isLoading {
                viewModel.loadMore()
            }
        }
    }
}

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

        @Published var state: LoadingState = .loading

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

#Preview {
    GithubListScreen()
}
