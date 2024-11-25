//
//  APIClient.swift
//  WhopTakeHome
//
//  Created by Ethan Pippin on 11/24/24.
//

import Foundation

protocol APIClient {
    
    // For demo, assume server always has a page of content
    // at the given index.
    /// Get the page of content at the given index.
    func getPage(index: Int) async throws -> [WebsiteContent]
}

class BasicAPIClient: APIClient {
    
    // For demo, make a mock folder
    private func makeMockFolder() -> WebsiteContent {
        [
            .folder(.init(title: "Social Media", contents: [
                .init(title: "Instagram", url: URL(string: "https://instagram.com")!),
                .init(title: "Facebook", url: URL(string: "https://facebook.com")!),
                .init(title: "Twitter", url: URL(string: "https://twitter.com")!),
                .init(title: "LinkedIn", url: URL(string: "https://linkedin.com")!),
                .init(title: "Snapchat", url: URL(string: "https://snapchat.com")!),
            ])),
            .folder(.init(title: "Shopping", contents: [
                .init(title: "Amazon", url: URL(string: "https://amazon.com")!),
                .init(title: "Walmart", url: URL(string: "https://walmart.com")!),
                .init(title: "Target", url: URL(string: "https://target.com")!),
                .init(title: "Best Buy", url: URL(string: "https://bestbuy.com")!),
            ])),
            .folder(.init(title: "News", contents: [
                .init(title: "Washington Post", url: URL(string: "https://washingtonpost.com")!),
                .init(title: "New York Times", url: URL(string: "https://nytimes.com")!),
                .init(title: "CNN", url: URL(string: "https://cnn.com")!),
                .init(title: "Fox News", url: URL(string: "https://foxnews.com")!),
                .init(title: "BBC", url: URL(string: "https://bbc.com")!),
                .init(title: "Al Jazeera", url: URL(string: "https://aljazeera.com")!),
            ])),
        ]
        .randomElement()!
    }
    
    // For demo, make a mock website
    private func makeMockStaticItem() -> WebsiteContent {
        [
            .static(.init(title: "Google", url: URL(string: "https://google.com")!)),
            .static(.init(title: "Apple", url: URL(string: "https://apple.com")!)),
            .static(.init(title: "Microsoft", url: URL(string: "https://microsoft.com")!)),
            .static(.init(title: "YouTube", url: URL(string: "https://youtube.com")!)),
            .static(.init(title: "Reddit", url: URL(string: "https://reddit.com")!)),
            .static(.init(title: "Twitch", url: URL(string: "https://twitch.com")!)),
            .static(.init(title: "Wikipedia", url: URL(string: "https://wikipedia.com")!)),
            .static(.init(title: "GitHub", url: URL(string: "https://github.com")!)),
            .static(.init(title: "Stack Overflow", url: URL(string: "https://stackoverflow.com")!)),
            .static(.init(title: "Dribbble", url: URL(string: "https://dribbble.com")!)),
        ]
        .randomElement()!
    }
    
    // For demo, make a mock page of data
    private func makeMockPage() -> [WebsiteContent] {
        var items: [WebsiteContent] = []
        
        for _ in 0 ..< 100 {
            if Double.random(in: 0 ... 1) < 0.3 {
                items.append(makeMockFolder())
            } else {
                items.append(makeMockStaticItem())
            }
        }
        
        return items
    }
    
    func getPage(index: Int) async throws -> [WebsiteContent] {
        
        // For demo, allow simulating a delay in fetching pages
        if AppSettings.shared.listPageLoadTime > 0 {
            try? await Task.sleep(for: .seconds(AppSettings.shared.listPageLoadTime))
        }
        
        return makeMockPage()
    }
}
