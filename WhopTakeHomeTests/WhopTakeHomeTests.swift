//
//  WhopTakeHomeTests.swift
//  WhopTakeHomeTests
//
//  Created by Ethan Pippin on 11/24/24.
//

import Testing
@testable import WhopTakeHome

struct WhopTakeHomeTests {

    @Test
    func testContentViewModelPaging() async throws {

        let viewModel = ContentViewModel(apiClient: MockAPIClient())
        
        #expect(viewModel.state == .loading)
        
        viewModel.getNextPage()
        
        try await Task.sleep(for: .seconds(1))
        
        #expect(viewModel.state == .content)
        #expect(viewModel.rows.count == 3)
        
        // Would typically test with a controllable
        // id system and verify against ids
        #expect(viewModel.rows[0].title == "0")
        #expect(viewModel.rows[1].title == "1")
        #expect(viewModel.rows[2].title == "2")
    }
    
    @Test
    func testAPIClientPaging() async throws {
            
        let apiClient = MockAPIClient()
            
        let response = try await apiClient.getPage(index: 0)
            
        #expect(response.count == 3)
        
        #expect(response[0].title == "0")
        #expect(response[1].title == "1")
        #expect(response[2].title == "2")
    }
}
