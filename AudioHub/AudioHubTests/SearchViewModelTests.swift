import Testing
import Combine
import Foundation
@testable import AudioHub

// MARK: - Mock Dependencies
final class MockSearchAPI: SearchAPIProtocol {
    var searchResult: Result<SearchResponse, Error> = .success(SearchResponse(sections: []))
    var searchCallCount = 0
    var lastSearchQuery: String?
    
    func search(query: String) async throws -> SearchResponse {
        searchCallCount += 1
        lastSearchQuery = query
        switch searchResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}

@MainActor
final class MockSearchCoordinator: SearchCoordinator {
    var navigateToHomeCallCount = 0
    
    func navigateToHome() {
        navigateToHomeCallCount += 1
    }
}

// MARK: - Test Data
extension SearchViewModelTests {
    static func createMockSearchSection(
        content: [SearchContentItem] = [],
        contentType: String = "audio",
        name: String = "Test Section",
        order: String = "1",
        type: String = "section"
    ) -> SearchSection {
        SearchSection(
            content: content,
            contentType: contentType,
            name: name,
            order: order,
            type: type
        )
    }
    
    static func createMockSearchResponse(sections: [SearchSection] = []) -> SearchResponse {
        SearchResponse(sections: sections)
    }
}

@Suite
struct SearchViewModelTests {
    let mockAPI = MockSearchAPI()
    let mockCoordinator: MockSearchCoordinator
    let viewModel: SearchViewModel

    init() async {
        self.mockCoordinator = await MockSearchCoordinator()
        self.viewModel = await SearchViewModel(
            searchAPI: mockAPI,
            coordinator: mockCoordinator,
            scheduler: ImmediateScheduler.shared
        )
    }
    
    @Test("SearchViewModel should initialize with correct default values")
    func testInitialization() async throws {
        await #expect(viewModel.searchText == "")
        await #expect(viewModel.searchResults.isEmpty)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == nil)
        await #expect(viewModel.hasSearched == false)
    }
    
    @Test("performSearch should not search when query is empty or whitespace only")
    func testPerformSearchWithEmptyQuery() async throws {
        // Test with empty string
        await MainActor.run {
            viewModel.searchText = ""
        }
        
        #expect(mockAPI.searchCallCount == 0)
        await #expect(viewModel.searchResults.isEmpty)
        await #expect(viewModel.hasSearched == false)
        
        // Test with whitespace only
        await MainActor.run {
            viewModel.searchText = "   "
        }
        
        #expect(mockAPI.searchCallCount == 0)
        await #expect(viewModel.searchResults.isEmpty)
        await #expect(viewModel.hasSearched == false)
    }
    
    @Test("performSearch should set loading state and call API with valid query")
    func testPerformSearchWithValidQuery() async throws {
        let mockSections = [
            Self.createMockSearchSection(name: "Section 1"),
            Self.createMockSearchSection(name: "Section 2")
        ]
        let mockResponse = Self.createMockSearchResponse(sections: mockSections)
        mockAPI.searchResult = .success(mockResponse)
        
        await MainActor.run {
            viewModel.searchText = "test query"
        }
        
        try await Task.sleep(for: .seconds(0.1)) // Simulate debounce delay
        
        #expect(mockAPI.searchCallCount == 1)
        #expect(mockAPI.lastSearchQuery == "test query")
        await #expect(viewModel.searchResults.count == 2)
        await #expect(viewModel.searchResults[0].name == "Section 1")
        await #expect(viewModel.searchResults[1].name == "Section 2")
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.hasSearched == true)
        await #expect(viewModel.errorMessage == nil)
    }
    
    @Test("performSearch should handle API errors correctly")
    func testPerformSearchWithError() async throws {
        let testError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Test error message"])
        mockAPI.searchResult = .failure(testError)
        
        await MainActor.run {
            viewModel.searchText = "test query"
        }
        
        try await Task.sleep(for: .seconds(0.1))
                
        #expect(mockAPI.searchCallCount == 1)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.hasSearched == true)
        await #expect(viewModel.errorMessage == "Test error message")
        await #expect(viewModel.searchResults.isEmpty)
    }
    
    @Test("clearSearch should reset all search state")
    func testClearSearch() async throws {
        // Set some state by performing a search
        await MainActor.run {
            viewModel.searchText = "test query"
        }
        
        // Perform a search to set the state
        let mockSections = [Self.createMockSearchSection()]
        let mockResponse = Self.createMockSearchResponse(sections: mockSections)
        mockAPI.searchResult = .success(mockResponse)
        
        try await Task.sleep(for: .seconds(0.1))
                
        // Verify state was set
        await #expect(viewModel.searchResults.count == 1)
        await #expect(viewModel.hasSearched == true)
        
        await viewModel.clearSearch()
        
        await #expect(viewModel.searchText == "")
        await #expect(viewModel.searchResults.isEmpty)
        await #expect(viewModel.errorMessage == nil)
        await #expect(viewModel.hasSearched == false)
    }
    
    @Test("searchTextChanged should clear search when text becomes empty")
    func testSearchTextChanged() async throws {
        // Set some state by performing a search
        await MainActor.run {
            viewModel.searchText = "test query"
        }
        let mockSections = [Self.createMockSearchSection()]
        let mockResponse = Self.createMockSearchResponse(sections: mockSections)
        mockAPI.searchResult = .success(mockResponse)
        
        try await Task.sleep(for: .seconds(0.1))
                
        // Verify state was set
        await #expect(viewModel.searchResults.count == 1)
        await #expect(viewModel.hasSearched == true)
        
        // Change text to empty
        await MainActor.run {
            viewModel.searchText = ""
        }
        await viewModel.searchTextChanged()
        
        await #expect(viewModel.searchResults.isEmpty)
        await #expect(viewModel.hasSearched == false)
        await #expect(viewModel.errorMessage == nil)
    }
    
    @Test("searchTextChanged should not clear search when text is not empty")
    func testSearchTextChangedWithNonEmptyText() async throws {
        // Set some state by performing a search
        await MainActor.run {
            viewModel.searchText = "test query"
        }
        let mockSection = Self.createMockSearchSection()
        let mockSections = [mockSection]
        let mockResponse = Self.createMockSearchResponse(sections: mockSections)
        mockAPI.searchResult = .success(mockResponse)
        
        try await Task.sleep(for: .seconds(0.1))
                
        // Verify state was set
        await #expect(viewModel.searchResults.count == 1)
        await #expect(viewModel.hasSearched == true)
        
        // Change text to non-empty
        await MainActor.run {
            viewModel.searchText = "new query"
        }
        await viewModel.searchTextChanged()
        
        await #expect(viewModel.searchResults.count == 1)
        await #expect(viewModel.searchResults[0].id == mockSection.id)
        await #expect(viewModel.hasSearched == true)
    }
    
    @Test("goToHome should call coordinator navigateToHome method")
    func testGoToHome() async throws {
        await #expect(mockCoordinator.navigateToHomeCallCount == 0)
        
        await viewModel.goToHome()
        
        await #expect(mockCoordinator.navigateToHomeCallCount == 1)
    }
    
    @Test("performSearch should preserve search results on subsequent successful searches")
    func testPreserveSearchResultsOnSubsequentSearches() async throws {
        // First search
        let firstSections = [Self.createMockSearchSection(name: "First Section")]
        mockAPI.searchResult = .success(Self.createMockSearchResponse(sections: firstSections))
        await MainActor.run {
            viewModel.searchText = "first query"
        }
        
        try await Task.sleep(for: .seconds(0.1))
                
        await #expect(viewModel.searchResults.count == 1)
        await #expect(viewModel.searchResults[0].name == "First Section")
        
        // Second search
        let secondSections = [
            Self.createMockSearchSection(name: "Second Section 1"),
            Self.createMockSearchSection(name: "Second Section 2")
        ]
        mockAPI.searchResult = .success(Self.createMockSearchResponse(sections: secondSections))
        await MainActor.run {
            viewModel.searchText = "second query"
        }
        
        try await Task.sleep(for: .seconds(0.1))
                
        await #expect(viewModel.searchResults.count == 2)
        await #expect(viewModel.searchResults[0].name == "Second Section 1")
        await #expect(viewModel.searchResults[1].name == "Second Section 2")
    }
}
