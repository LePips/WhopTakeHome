//
//  MockAPIClient.swift
//  WhopTakeHomeTests
//
//  Created by Ethan Pippin on 11/24/24.
//

import Foundation
@testable import WhopTakeHome

class MockAPIClient: APIClient {
    
    var index = 0
    
    func getPage(index: Int) async throws -> [WebsiteContent] {
        let page = [
            WebsiteContent.static(
                .init(
                    title: "\(index)",
                    url: URL(string: "https://www.example.com")!
                )
            ),
            WebsiteContent.static(
                .init(
                    title: "\(index + 1)",
                    url: URL(string: "https://www.example.com")!
                )
            ),
            WebsiteContent.static(
                .init(
                    title: "\(index + 2)",
                    url: URL(string: "https://www.example.com")!
                )
            )
        ]
        
        self.index += 3
        
        return page
    }
}
