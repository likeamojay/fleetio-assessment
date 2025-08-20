//
//  CommentsListView.swift
//  Fleetio-Assement-James-Lane
//
//  Created by James Lane on 8/20/25.
//

import SwiftUI

struct CommentsListView: View {

    @StateObject private var viewModel = CommentsListViewModel()

    var body: some View {
        Group {
            if viewModel.isInitialLoading {
                Text("Loading Comments...")
                    .foregroundColor(.gray)
                    .padding()
            } else if !viewModel.errorString.isEmpty {
                Text(viewModel.errorString)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List(viewModel.comments) { comment in
                    CommentRow(entry: comment)
                }
            }
        }
        .onAppear {
            if viewModel.comments.isEmpty {
                Task {
                    await viewModel.fetchAllComments()
                }
            }
        }
    }
}
