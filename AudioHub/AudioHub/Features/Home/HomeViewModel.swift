import Foundation
import SwiftUI

@MainActor
@Observable
final class HomeViewModel {
    private let api: HomeSectionsAPIProtocol
    
    var sections: [HomeSection] = []
    var isLoading = false
    var isLoadingNextPage = false
    var errorMessage: String?
    var hasMorePages = true
    var currentPage = 1
    
    init(api: HomeSectionsAPIProtocol = HomeSectionsAPI()) {
        self.api = api
    }
    
    func loadHomeSections() async {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        hasMorePages = true
        
        do {
            let response = try await api.fetchHomeSections(page: nil)
            sections = response.sections.sorted { $0.order < $1.order }
            currentPage = response.pagination.nextPage?.compactMap { Int("\($0)") }.first ?? 1
            hasMorePages = response.pagination.nextPage != nil
        } catch {
            print("❌ Error loading home sections: \(error)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadNextPage() async {
        guard hasMorePages && !isLoadingNextPage && currentPage > 1 else { return }
        
        isLoadingNextPage = true
        
        do {
            let response = try await api.fetchHomeSections(page: "\(currentPage)")
            let newSections = response.sections.sorted { $0.order < $1.order }
            sections.append(contentsOf: newSections)
            currentPage = response.pagination.nextPage?.compactMap { Int("\($0)") }.first ?? 1
            hasMorePages = response.pagination.nextPage != nil
        } catch {
            print("❌ Error loading next page: \(error)")
            // Don't show error for pagination failures, just log them
        }
        
        isLoadingNextPage = false
    }
    
    func refresh() async {
        await loadHomeSections()
    }
}
