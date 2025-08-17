import Foundation
import SwiftUI

@Observable
final class SearchViewModel {
    // MARK: - Dependencies
    private let searchAPI: SearchAPIProtocol
    private let coordinator: SearchCoordinator
    
    // MARK: - State
    var searchText = ""
    private(set) var searchResults: [SearchSection] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var hasSearched = false
    
    // MARK: - Initialization
    init(searchAPI: SearchAPIProtocol = SearchAPI(), coordinator: SearchCoordinator) {
        self.searchAPI = searchAPI
        self.coordinator = coordinator
    }
    
    // MARK: - Public Methods
    func performSearch() async {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            hasSearched = false
            return
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let response = try await searchAPI.search(query: searchText)
            await MainActor.run {
                searchResults = response.sections
                hasSearched = true
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
                hasSearched = true
            }
        }
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
        errorMessage = nil
        hasSearched = false
    }
    
    func searchTextChanged() {
        // Reset search state when text changes
        if searchText.isEmpty {
            clearSearch()
        }
    }

    @MainActor
    func goToHome() {
        coordinator.navigateToHome()
    }
}
