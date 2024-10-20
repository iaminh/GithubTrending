//
//  GithubDetailVC.swift
//  GithubTrendings
//
//  Created by Chu Anh Minh on 8/23/20.
//  Copyright © 2020 MinhChu. All rights reserved.
//

import SwiftUI

struct GithubDetailScreen: View {
    @StateObject private var viewModel: GithubDetailViewModel

    init(viewModel: GithubDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.description)
                .font(.body)
                .padding(.horizontal)

            Text("Language: \(viewModel.language)")
                .font(.subheadline)
                .padding(.horizontal)

            Text("Stars: \(viewModel.stars)")
                .font(.subheadline)
                .padding(.horizontal)

            Text("Forks: \(viewModel.forks)")
                .font(.subheadline)
                .padding(.horizontal)

            Text("Created: \(viewModel.created)")
                .font(.subheadline)
                .padding(.horizontal)

            Spacer()

            Button(action: {
                if let url = viewModel.openUrl {
                    UIApplication.shared.open(url)
                }
            }) {
                Text(NSLocalizedString("open_git", comment: ""))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .navigationTitle(viewModel.title)
    }
}
