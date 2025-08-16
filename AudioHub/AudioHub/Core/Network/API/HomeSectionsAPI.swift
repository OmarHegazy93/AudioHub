import Foundation

/// API service for home sections
protocol HomeSectionsAPIProtocol {
    func fetchHomeSections() async throws -> HomeSectionsResponse
}

/// Implementation of home sections API
final class HomeSectionsAPI: HomeSectionsAPIProtocol {
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func fetchHomeSections() async throws -> HomeSectionsResponse {
        let request = HomeSectionsRequest()
        return try await requestManager.perform(request)
    }
}

/// Request for home sections
struct HomeSectionsRequest: RequestProtocol {
    let host = "api-v2-b2sit6oh3a-uc.a.run.app"
    let path = "/home_sections"
    let requestType: RequestType = .GET
}
