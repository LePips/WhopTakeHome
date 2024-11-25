//
//  ContentView.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import SwiftUI

struct ContentView: View {
    
    @Namespace
    private var contentNamespace
    
    /// The size of the content view.
    @State
    private var contentSize: CGSize = .zero
    /// The coordinator for this navigation flow.
    @Bindable
    private var coordinator = MainCoordinator()
    /// The ids to track expanded sections.
    @State
    private var expandedSections: Set<UUID> = []
    /// Whether the view has appeared or not.
    @State
    private var hasAppeared = false
    
    /// The view model for this content view.
    private var viewModel = ContentViewModel(apiClient: BasicAPIClient())
    
    /// Rows for a loading state to be redacted.
    private var loadingRows: [WebsiteContent] {
        var items: [WebsiteContent] = []
        
        for _ in 0 ..< 5 {
            let title = String(repeating: "A", count: Int.random(in: 10 ... 20))
            
            if Double.random(in: 0 ... 1) < 0.3 {
                items.append(.folder(.init(title: title, contents: [])))
            } else {
                items.append(.static(.init(title: title, url: URL(string: "https://example.com")!)))
            }
        }
        
        return items
    }
    
    // MARK: - body
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                switch viewModel.state {
                case .content:
                    contentView
                case .error:
                    errorView
                case .loading:
                    loadingView
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
            .onAppear {
                guard !hasAppeared else { return }
                
                hasAppeared = true
                Task { await viewModel.refresh() }
            }
            .animation(.linear(duration: 0.2), value: viewModel.state)
            .navigationTitle("Bookmarks")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: MainCoordinator.Destination.self) { destination in
                switch destination {
                case let .webView(content):
                    WebContentView(content: content)
                        .environment(coordinator)
                        .apply { v in
                            // on iOS 18, use new zoom transition.
                            if #available(iOS 18.0, *) {
                                v.navigationTransition(.zoom(sourceID: "zoom-\(content.id)", in: contentNamespace))
                            } else {
                                v
                            }
                        }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if viewModel.backgroundStates.contains(.gettingNextPage) {
                        ProgressView()
                    }
                }
            }
        }
    }
    
    // MARK: - contentView
    
    /// The main content view for displaying websites.
    @ViewBuilder
    private var contentView: some View {
        List {
            ForEach(viewModel.rows) { row in
                switch row {
                case let .static(content):
                    makeStaticRow(content)
                case let .folder(content):
                    makeFolderRow(content)
                }
            }
            .listRowSeparator(.hidden)
            
            // Placeholder rows while loading the next page
            if viewModel.backgroundStates.contains(.gettingNextPage) {
                ForEach(loadingRows) { row in
                    switch row {
                    case let .static(content):
                        makeStaticRow(content)
                    case let .folder(content):
                        makeFolderRow(content)
                    }
                }
                .listRowSeparator(.hidden)
                .redacted(reason: .placeholder)
                .allowsHitTesting(false)
            }
            
            // Track offset to determine when to get the next page.
            // Would typically introspect or use iOS 18's `onScrollGeometryChange`
            Color.clear
                .frame(height: 1)
                .onFrameChanged { newFrame in
                    
                    let bottomOffset = contentSize.height * 2
                    let distanceFromBottom = contentSize.height - newFrame.maxY
                    
                    if distanceFromBottom <= bottomOffset {
                        viewModel.getNextPageBackground()
                    }
                }
                .listRowSeparator(.hidden)
        }
        .animation(.linear(duration: 0.2), value: viewModel.rows)
        .listStyle(.plain)
        .onFrameChanged { newFrame in
            contentSize = newFrame.size
        }
    }
    
    /// Makes the row for a static website.
    @ViewBuilder
    private func makeStaticRow(_ row: WebsiteContent.StaticWebsite) -> some View {
        Button(row.title) {
            coordinator.push(.webView(row))
        }
        .apply { v in
            if #available(iOS 18.0, *) {
                // on iOS 18, use new zoom transition.
                v.matchedTransitionSource(id: "zoom-\(row.id)", in: contentNamespace)
            } else {
                v
            }
        }
    }
    
    /// Makes the row for a folder of websites.
    @ViewBuilder
    private func makeFolderRow(_ folder: WebsiteContent.Folder) -> some View {
        DisclosureGroup(
            isExpanded: .init(
                get: { expandedSections.contains(folder.id) },
                set: { _ in expandedSections.toggle(folder.id) }
            )) {
                ForEach(folder.contents) { row in
                    makeStaticRow(row)
                }
            } label: {
                Label(folder.title, systemImage: "folder.fill")
            }
    }
    
    // MARK: - errorView
    
    @ViewBuilder
    private var errorView: some View {
        ErrorView {
            await viewModel.refresh()
        }
    }
    
    // MARK: - loadingView
    
    @ViewBuilder
    private var loadingView: some View {
        List {
            ForEach(loadingRows) { row in
                switch row {
                case let .static(content):
                    makeStaticRow(content)
                case let .folder(content):
                    makeFolderRow(content)
                }
            }
            .listRowSeparator(.hidden)
            .redacted(reason: .placeholder)
        }
        .listStyle(.plain)
        .scrollDisabled(true)
        .allowsHitTesting(false)
        .pulse()
    }
}

#Preview {
    ContentView()
}
