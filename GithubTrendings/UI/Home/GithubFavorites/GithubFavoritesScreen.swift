//
//  GithubFavoritesVC.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import SwiftUI

struct GithubFavoritesScreen: View {
    @StateObject private var viewModel = GithubFavoritesViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.cells, id: \.self) { cell in
                makeCell(cell)
            }
            .navigationTitle("Favorites")
        }
        .alert(item: $viewModel.selectedRepo) { repo in
            Alert(title: Text(repo.name), message: Text(repo.description ?? "No description".localized), dismissButton: .default(Text("OK".localized)))
        }
    }

    private func makeCell(_ cell: GithubFavoritesViewModel.Cell) -> some View {
        HStack {
            // Display avatar
            AsyncImage(url: URL(string: cell.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }

            VStack(alignment: .leading) {
                Text(cell.title)
                    .font(.headline)
                if let subtitle = cell.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            // Bookmark button
            Button(action: {
                guard let index = viewModel.cells.firstIndex(where: { $0.id == cell.id }) else { return }
//                viewModel.toggleBookmark(for: Array(viewModel.udManager.reposRelay.value)[index])
            }) {
                Image(systemName: cell.bookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard let index = viewModel.cells.firstIndex(where: { $0.id == cell.id }) else { return }
            viewModel.selectRepo(at: index)
        }
    }
}
