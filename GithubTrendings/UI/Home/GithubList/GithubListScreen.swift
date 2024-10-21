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
                ForEach(viewModel.repos) { cell in
                    makeCell(cell: cell, isLast: cell == viewModel.repos.last)
                }
            }
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Repositories")
    }

    private func makeCell(cell: GithubListViewModel.Cell, isLast: Bool) -> some View {
        ZStack {
            HStack {
                NetworkImage(url: cell.avatarUrl)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text(cell.title)
                        .font(.headline)
                    if let description = cell.subtitle {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.trailing, 36)

                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                cell.onTap()
            }

            HStack {
                Spacer()
                Image(cell.bookmarked ? "bookmark-f" : "bookmark")
                    .onTapGesture {
                        cell.onBookmarkTap()
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

#Preview {
    GithubListScreen()
}
