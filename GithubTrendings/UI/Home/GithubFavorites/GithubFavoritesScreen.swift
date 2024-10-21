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
        List(viewModel.cells, id: \.self) { cell in
            makeCell(cell)
        }
    }

    private func makeCell(_ cell: GithubFavoritesViewModel.Cell) -> some View {
        HStack {
            NetworkImage(url: cell.avatarUrl)
                .frame(width: 50, height: 50)
                .clipShape(Circle())

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
            Button(action: cell.onTap) {
                Image("bookmark-f")
                    .foregroundColor(.black)
            }
        }
        .contentShape(Rectangle())
    }
}
