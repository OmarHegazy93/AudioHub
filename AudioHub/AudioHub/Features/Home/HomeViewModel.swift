import Foundation
import SwiftUI

@MainActor
@Observable
final class HomeViewModel {
    private let api: HomeSectionsAPIProtocol
    
    var sections: [HomeSection] = []
    var isLoading = false
    var errorMessage: String?
    
    init(api: HomeSectionsAPIProtocol = HomeSectionsAPI()) {
        self.api = api
    }
    
    func loadHomeSections() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await api.fetchHomeSections()
            sections = response.sections.sorted { $0.order < $1.order }
        } catch {
            print("❌ Error loading home sections: \(error)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
