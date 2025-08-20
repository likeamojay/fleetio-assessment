//
//  CommentsListViewModel.swift
//  Fleetio-Assement-James-Lane
//
//  Created by James Lane on 8/20/25.
//

import Foundation
import Combine

@MainActor
class CommentsListViewModel: ObservableObject {

    @Published var isInitialLoading = false
    @Published var errorString = ""
    @Published private(set) var comments: [CommentEntry] = []
    @Published var isFetchingNextPage = false

    private let kUrlString = "https://secure.fleetio.com/api/comments"
    private var startCursor: String?
    private var nextCursor: String?
    private var perPage = 10

    var hasNextPage: Bool {
        nextCursor != nil
    }

    func fetchAllComments() async {
        await fetchComments()

        if isFetchingNextPage {
            return
        }
        while hasNextPage {
            await fetchComments()
        }
    }

    private func fetchComments() async {
        guard !isFetchingNextPage else { return }
        if nextCursor == nil && startCursor != nil {
            return
        }

        isFetchingNextPage = nextCursor != nil
        if startCursor == nil {
            isInitialLoading = true
        }

        defer {
            isInitialLoading = false
            isFetchingNextPage = false
        }

        guard var urlComponents = URLComponents(string: kUrlString) else { return }

        var queryItems = [URLQueryItem(name: "per_page", value: "\(self.perPage)")]
        if let nextCursor {
            queryItems.append(URLQueryItem(name: "start_cursor", value: nextCursor))
        }
        queryItems.append(URLQueryItem(name: "filter[commentable_type][eq]", value: "Vehicle"))

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            errorString = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Token \(Utils.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(Utils.accountToken, forHTTPHeaderField: "Account-Token")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                errorString = "HTTP Error \(String(describing: (response as? HTTPURLResponse)?.statusCode))"
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let commentsResponse = try decoder.decode(CommentEntriesResponse.self, from: data)
            comments += commentsResponse.records

            self.startCursor = commentsResponse.startCursor
            self.nextCursor = commentsResponse.nextCursor

            if startCursor == nil {
                errorString = "No Comments Entered"
            }
        } catch {
            errorString = "Failed to fetch comments: \(error.localizedDescription)"
            self.nextCursor = nil
        }
    }

    func shouldLoadNextPage(currentItem: CommentEntry) -> Bool {
        guard !isFetchingNextPage else { return false }
        guard hasNextPage else { return false }
        return currentItem.id == comments.last?.id
    }

    var isFirstPage: Bool {
        return self.comments.count == self.perPage
    }
}

