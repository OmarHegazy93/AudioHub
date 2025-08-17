import Foundation
import Combine
import SwiftUI

@Observable
@MainActor
final class SearchViewModel {
    // MARK: - Dependencies
    private let searchAPI: SearchAPIProtocol
    private let coordinator: SearchCoordinator
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - State
    @Published
    @ObservationIgnored
    var searchText = ""
    private(set) var searchResults: [SearchSection] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var hasSearched = false
    
    // MARK: - Initialization
    init<S: Scheduler>(
        searchAPI: SearchAPIProtocol,
        coordinator: SearchCoordinator,
        scheduler: S = DispatchQueue.main
    ) {
        self.searchAPI = searchAPI
        self.coordinator = coordinator
        setupBindings(using: scheduler)
    }
    
    // MARK: - Bindings
    private func setupBindings(using scheduler: some Scheduler) {
        $searchText
            .dropFirst()
            .removeDuplicates()
            .debounce(for: .milliseconds(200), scheduler: scheduler)
            .sink { [weak self] txt in
                print("✅ schedler: \(scheduler)")
                print("🔍 Search text changed: \(txt)")
                
                Task {
                    await self?.performSearch()
                }
            }
            .store(in: &cancellables)
    }
    
    func retrySearch() async {
        await performSearch()
    }
    
    // MARK: - Public Methods
    private func performSearch() async {
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
