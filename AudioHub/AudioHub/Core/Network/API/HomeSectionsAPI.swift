import Foundation

/// API service for home sections
protocol HomeSectionsAPIProtocol {
    func fetchHomeSections(page: String?) async throws -> HomeSectionsResponse
}

/// Implementation of home sections API
final class HomeSectionsAPI: HomeSectionsAPIProtocol {
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func fetchHomeSections(page: String? = nil) async throws -> HomeSectionsResponse {
        let request = HomeSectionsRequest(page: page)
        return try await requestManager.perform(request)
    }
}

/// Request for home sections
struct HomeSectionsRequest: RequestProtocol {
    let host = "api-v2-b2sit6oh3a-uc.a.run.app"
    let path: String
    let requestType: RequestType = .GET
    private(set) var urlParams = [String: String?]()
    
    init(page: String? = nil) {
        self.path = "/home_sections"
        self.urlParams["page"] = page ?? ""
    }
}
