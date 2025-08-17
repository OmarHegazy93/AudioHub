import Testing
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
        self.viewModel = SearchViewModel(searchAPI: mockAPI, coordinator: mockCoordinator)
    }
    
    @Test("SearchViewModel should initialize with correct default values")
    func testInitialization() async throws {
        #expect(viewModel.searchText == "")
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.hasSearched == false)
    }
    
    @Test("performSearch should not search when query is empty or whitespace only")
    func testPerformSearchWithEmptyQuery() async throws {
        // Test with empty string
        viewModel.searchText = ""
        await viewModel.performSearch()
        
        #expect(mockAPI.searchCallCount == 0)
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.hasSearched == false)
        
        // Test with whitespace only
        viewModel.searchText = "   "
        await viewModel.performSearch()
        
        #expect(mockAPI.searchCallCount == 0)
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.hasSearched == false)
    }
    
    @Test("performSearch should set loading state and call API with valid query")
    func testPerformSearchWithValidQuery() async throws {
        let mockSections = [
            Self.createMockSearchSection(name: "Section 1"),
            Self.createMockSearchSection(name: "Section 2")
        ]
        let mockResponse = Self.createMockSearchResponse(sections: mockSections)
        mockAPI.searchResult = .success(mockResponse)
        
        viewModel.searchText = "test query"
        
        // Perform search
        await viewModel.performSearch()
        
        #expect(mockAPI.searchCallCount == 1)
        #expect(mockAPI.lastSearchQuery == "test query")
        #expect(viewModel.searchResults.count == 2)
        #expect(viewModel.searchResults[0].name == "Section 1")
        #expect(viewModel.searchResults[1].name == "Section 2")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.hasSearched == true)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("performSearch should handle API errors correctly")
    func testPerformSearchWithError() async throws {
        let testError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Test error message"])
        mockAPI.searchResult = .failure(testError)
        
        viewModel.searchText = "test query"
        
        await viewModel.performSearch()
        
        #expect(mockAPI.searchCallCount == 1)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.hasSearched == true)
        #expect(viewModel.errorMessage == "Test error message")
        #expect(viewModel.searchResults.isEmpty)
    }
    
    @Test("clearSearch should reset all search state")
    func testClearSearch() async throws {
        // Set some state by performing a search
        viewModel.searchText = "test query"
        
        // Perform a search to set the state
        let mockSections = [Self.createMockSearchSection()]
        let mockResponse = Self.createMockSearchResponse(sections: mockSections)
        mockAPI.searchResult = .success(mockResponse)
        
        await viewModel.performSearch()
        
        // Verify state was set
        #expect(viewModel.searchResults.count == 1)
        #expect(viewModel.hasSearched == true)
        
        viewModel.clearSearch()
        
        #expect(viewModel.searchText == "")
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.hasSearched == false)
    }
    
    @Test("searchTextChanged should clear search when text becomes empty")
    func testSearchTextChanged() async throws {
        // Set some state by performing a search
        viewModel.searchText = "test query"
        let mockSections = [Self.createMockSearchSection()]
        let mockResponse = Self.createMockSearchResponse(sections: mockSections)
        mockAPI.searchResult = .success(mockResponse)
        
        await viewModel.performSearch()
        
        // Verify state was set
        #expect(viewModel.searchResults.count == 1)
        #expect(viewModel.hasSearched == true)
        
        // Change text to empty
        viewModel.searchText = ""
        viewModel.searchTextChanged()
        
        #expect(viewModel.searchResults.isEmpty)
        #expect(viewModel.hasSearched == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("searchTextChanged should not clear search when text is not empty")
    func testSearchTextChangedWithNonEmptyText() async throws {
        // Set some state by performing a search
        viewModel.searchText = "test query"
        let mockSection = Self.createMockSearchSection()
        let mockSections = [mockSection]
        let mockResponse = Self.createMockSearchResponse(sections: mockSections)
        mockAPI.searchResult = .success(mockResponse)
        
        await viewModel.performSearch()
        
        // Verify state was set
        #expect(viewModel.searchResults.count == 1)
        #expect(viewModel.hasSearched == true)
        
        // Change text to non-empty
        viewModel.searchText = "new query"
        viewModel.searchTextChanged()
        
        #expect(viewModel.searchResults.count == 1)
        #expect(viewModel.searchResults[0].id == mockSection.id)
        #expect(viewModel.hasSearched == true)
    }
    
    @Test("goToHome should call coordinator navigateToHome method")
    func testGoToHome() async throws {
        await #expect(mockCoordinator.navigateToHomeCallCount == 0)
        
        await viewModel.goToHome()
        
        await #expect(mockCoordinator.navigateToHomeCallCount == 1)
    }
    
    @Test("performSearch should handle concurrent search requests correctly")
    func testConcurrentSearchRequests() async throws {
        viewModel.searchText = "test query"
        
        // Start multiple concurrent searches
        let searchTask1 = Task { await viewModel.performSearch() }
        let searchTask2 = Task { await viewModel.performSearch() }
        let searchTask3 = Task { await viewModel.performSearch() }
        
        // Wait for all to complete
        await searchTask1.value
        await searchTask2.value
        await searchTask3.value
        
        // Should have made 3 API calls
        #expect(mockAPI.searchCallCount == 3)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("performSearch should preserve search results on subsequent successful searches")
    func testPreserveSearchResultsOnSubsequentSearches() async throws {
        // First search
        let firstSections = [Self.createMockSearchSection(name: "First Section")]
        mockAPI.searchResult = .success(Self.createMockSearchResponse(sections: firstSections))
        viewModel.searchText = "first query"
        
        await viewModel.performSearch()
        
        #expect(viewModel.searchResults.count == 1)
        #expect(viewModel.searchResults[0].name == "First Section")
        
        // Second search
        let secondSections = [
            Self.createMockSearchSection(name: "Second Section 1"),
            Self.createMockSearchSection(name: "Second Section 2")
        ]
        mockAPI.searchResult = .success(Self.createMockSearchResponse(sections: secondSections))
        viewModel.searchText = "second query"
        
        await viewModel.performSearch()
        
        #expect(viewModel.searchResults.count == 2)
        #expect(viewModel.searchResults[0].name == "Second Section 1")
        #expect(viewModel.searchResults[1].name == "Second Section 2")
    }
}
