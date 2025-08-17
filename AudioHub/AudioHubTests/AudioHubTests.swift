//
//  AudioHubTests.swift
//  AudioHubTests
//
//  Created by Omar Hegazy on 16/08/2025.
//

import Testing
import Foundation
@testable import AudioHub

// MARK: - Mock API for Testing
final class MockHomeSectionsAPI: HomeSectionsAPIProtocol {
    var shouldThrowError = false
    var mockResponse: HomeSectionsResponse?
    var fetchCallCount = 0
    var lastPageParameter: String?
    
    func fetchHomeSections(page: String?) async throws -> HomeSectionsResponse {
        fetchCallCount += 1
        lastPageParameter = page
        
        if shouldThrowError {
            throw NetworkError.invalidServerResponse
        }
        
        return mockResponse ?? HomeSectionsResponse(
            sections: [],
            pagination: Pagination(nextPage: nil, totalPages: 1)
        )
    }
}

// MARK: - Test Data Factory
struct TestDataFactory {
    static func createMockHomeSection(name: String, order: Int, contentType: ContentType) -> HomeSection {
        let mockContent: [any ContentItem] = []
        return HomeSection(
            name: name,
            type: .bigSquare,
            contentType: contentType,
            order: order,
            content: mockContent
        )
    }
    
    static func createMockHomeSectionsResponse(
        sections: [HomeSection] = [],
        nextPage: String? = nil,
        totalPages: Int? = 1
    ) -> HomeSectionsResponse {
        return HomeSectionsResponse(
            sections: sections,
            pagination: Pagination(nextPage: nextPage, totalPages: totalPages)
        )
    }
}

// MARK: - HomeViewModel Tests
struct HomeViewModelTests {
    let mockAPI = MockHomeSectionsAPI()
    var viewModel: HomeViewModel

    init() async {
        viewModel = await HomeViewModel(api: mockAPI)
    }
    
    // MARK: - Initialization Tests
    @Test 
    func testInitialization() async throws {
        await MainActor.run {
            #expect(viewModel.sections.isEmpty)
            #expect(!viewModel.isLoading)
            #expect(!viewModel.isLoadingNextPage)
            #expect(viewModel.errorMessage == nil)
            #expect(viewModel.hasMorePages)
            #expect(viewModel.currentPage == 1)
        }
    }
    
    // MARK: - Load Home Sections Tests
    @Test 
    func testLoadHomeSectionsSuccess() async throws {
        let mockSections = [
            TestDataFactory.createMockHomeSection(name: "Section 1", order: 2, contentType: .podcast),
            TestDataFactory.createMockHomeSection(name: "Section 2", order: 1, contentType: .episode)
        ]
        let mockResponse = TestDataFactory.createMockHomeSectionsResponse(
            sections: mockSections,
            nextPage: "2",
            totalPages: 3
        )
        
        mockAPI.mockResponse = mockResponse
        let viewModel = await HomeViewModel(api: mockAPI)
        
        await viewModel.loadHomeSections()
        
        await MainActor.run {
            #expect(viewModel.sections.count == 2)
            #expect(viewModel.sections[0].name == "Section 2") // Should be sorted by order
            #expect(viewModel.sections[1].name == "Section 1")
            #expect(viewModel.currentPage == 2)
            #expect(viewModel.hasMorePages)
            #expect(!viewModel.isLoading)
            #expect(viewModel.errorMessage == nil)
        }
        
        #expect(mockAPI.fetchCallCount == 1)
        #expect(mockAPI.lastPageParameter == nil)
    }
    
    @Test 
    func testLoadHomeSectionsFailure() async throws {
        mockAPI.shouldThrowError = true
        
        await viewModel.loadHomeSections()
        
        await MainActor.run {
            #expect(viewModel.sections.isEmpty)
            #expect(!viewModel.isLoading)
            #expect(viewModel.errorMessage != nil)
            #expect(viewModel.currentPage == 1)
            #expect(viewModel.hasMorePages)
        }
        
        #expect(mockAPI.fetchCallCount == 1)
    }
    
    @Test
     func testLoadHomeSectionsResetsState() async throws {
        let mockResponse = TestDataFactory.createMockHomeSectionsResponse(
            sections: [],
            nextPage: nil,
            totalPages: 1
        )
        mockAPI.mockResponse = mockResponse
        
        await viewModel.loadHomeSections()
        
        await #expect(viewModel.sections.isEmpty)
        await #expect(viewModel.errorMessage == nil)
        await #expect(viewModel.currentPage == 1)
        #expect(await viewModel.hasMorePages == false)
    }
    
    // MARK: - Load Next Page Tests
    @Test 
    func testLoadNextPageSuccess() async throws {
        // Note: Cannot directly set private(set) properties, so we test the behavior after loading
        // We need to first load some data to set up the state
        let initialResponse = TestDataFactory.createMockHomeSectionsResponse(
            sections: [],
            nextPage: "2",
            totalPages: 3
        )
        mockAPI.mockResponse = initialResponse
        await viewModel.loadHomeSections()
        
        let newSections = [
            TestDataFactory.createMockHomeSection(name: "New Section 1", order: 3, contentType: .podcast),
            TestDataFactory.createMockHomeSection(name: "New Section 2", order: 4, contentType: .episode)
        ]
        let mockResponse = TestDataFactory.createMockHomeSectionsResponse(
            sections: newSections,
            nextPage: "3",
            totalPages: 5
        )
        
        mockAPI.mockResponse = mockResponse
        
        await viewModel.loadNextPage()
        
        await MainActor.run {
            #expect(viewModel.sections.count == 2)
            #expect(viewModel.currentPage == 3)
            #expect(viewModel.hasMorePages)
            #expect(viewModel.isLoadingNextPage == false)
        }
        
        #expect(mockAPI.fetchCallCount == 2) // Initial load + next page
        #expect(mockAPI.lastPageParameter == "2")
    }
    
    // MARK: - Refresh Tests
    @Test
    func testRefreshCallsLoadHomeSections() async throws {
        let mockResponse = TestDataFactory.createMockHomeSectionsResponse(
            sections: [],
            nextPage: nil,
            totalPages: 1
        )
        mockAPI.mockResponse = mockResponse
        
        await viewModel.refresh()
        
        #expect(mockAPI.fetchCallCount == 1)
        
        await #expect(viewModel.isLoading == false)
    }
    
    // MARK: - Edge Cases
    @Test
    func testLoadHomeSectionsWithEmptyResponse() async throws {
        let mockResponse = TestDataFactory.createMockHomeSectionsResponse(
            sections: [],
            nextPage: nil,
            totalPages: 1
        )
        
        mockAPI.mockResponse = mockResponse
        let viewModel = await HomeViewModel(api: mockAPI)
        
        await viewModel.loadHomeSections()
        
        await #expect(viewModel.sections.isEmpty)
        await #expect(viewModel.currentPage == 1)
        await #expect(viewModel.hasMorePages == false)
    }
    
    @Test
    func testLoadHomeSectionsWithNilNextPage() async throws {
        let mockSections = [
            TestDataFactory.createMockHomeSection(name: "Section 1", order: 1, contentType: .podcast)
        ]
        let mockResponse = TestDataFactory.createMockHomeSectionsResponse(
            sections: mockSections,
            nextPage: nil,
            totalPages: 1
        )
        
        mockAPI.mockResponse = mockResponse
        let viewModel = await HomeViewModel(api: mockAPI)
        
        await viewModel.loadHomeSections()
        
        await #expect(viewModel.currentPage == 1)
        await #expect(viewModel.hasMorePages == false)
    }
    
    @Test
    func testLoadHomeSectionsWithInvalidNextPage() async throws {
        let mockSections = [
            TestDataFactory.createMockHomeSection(name: "Section 1", order: 1, contentType: .podcast)
        ]
        let mockResponse = TestDataFactory.createMockHomeSectionsResponse(
            sections: mockSections,
            nextPage: "invalid_page",
            totalPages: 2
        )
        
        mockAPI.mockResponse = mockResponse
        let viewModel = await HomeViewModel(api: mockAPI)
        
        await viewModel.loadHomeSections()
        
        await #expect(viewModel.currentPage == 1) // Should fallback to 1 when parsing fails
        #expect(await viewModel.hasMorePages)
    }
}
