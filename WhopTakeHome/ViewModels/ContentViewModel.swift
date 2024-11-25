//
//  ContentViewModel.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import Combine
import SwiftUI

@Observable
final class ContentViewModel {
    
    /// Background states that this view model may have.
    enum BackgroundState: Hashable {
        case gettingNextPage
    }
    
    /// Primary states that this view model may be in.
    enum State {
        case content
        case error
        case loading
    }
    
    /// The current API client.
    ///
    /// This would typically be constructed through a factory
    /// other other dependency injection method, but through the
    /// init is good enough for demo.
    private let apiClient: any APIClient
    
    /// The background states that this view model may have,
    /// like fetching the next page or other long tasks that
    /// don't require a primary state.
    private(set) var backgroundStates: Set<BackgroundState>
    
    /// The current page index of content to fetch from
    /// the API client.
    private(set) var pageIndex: Int
    
    /// The content rows that have been fetched from the API.
    private(set) var rows: [WebsiteContent]
    
    /// The primary state of this view model.
    private(set) var state: State
    
    /// The current task for retrieving the current page.
    private var currentPageTask: AnyCancellable?
    
    init(apiClient: any APIClient) {
        self.apiClient = apiClient
        self.backgroundStates = []
        self.pageIndex = 0
        self.rows = []
        self.state = .loading
    }
    
    /// Refresh the current view model, retrieving content
    /// from the first page.
    func refresh() async {
        currentPageTask = nil
        pageIndex = 0
        state = .loading
        
        getNextPage()
    }
    
    /// Gets the next page of content from the API client,
    /// setting the new state and updating row information.
    func getNextPage() {
        currentPageTask = Task {
            do {
                let nextPage = try await apiClient.getPage(index: pageIndex)
                
                await MainActor.run {
                    self.state = .content
                    self.rows.append(contentsOf: nextPage)
                }
            } catch {
                await MainActor.run {
                    self.state = .error
                }
            }
        }
        .asAnyCancellable()
    }
    
    /// Gets the next page of content from the API client in the background
    func getNextPageBackground() {
        
        guard !backgroundStates.contains(.gettingNextPage) else { return }
        
        currentPageTask = Task {
            await MainActor.run {
                _ = self.backgroundStates.insert(.gettingNextPage)
            }
            
            do {
                
                let nextPage = try await apiClient.getPage(index: pageIndex)
                
                await MainActor.run {
                    self.rows.append(contentsOf: nextPage)
                }
            } catch {
                // Would typically log to some logging system
                // and/or communicate an error to clients of
                // this view model.
                print(error.localizedDescription)
            }
            
            await MainActor.run {
                _ = self.backgroundStates.remove(.gettingNextPage)
            }
        }
        .asAnyCancellable()
    }
}
