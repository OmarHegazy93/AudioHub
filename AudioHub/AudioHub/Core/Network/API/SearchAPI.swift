import Foundation

/// API service for search functionality
protocol SearchAPIProtocol {
    func search(query: String) async throws -> SearchResponse
}

/// Implementation of search API
final class SearchAPI: SearchAPIProtocol {
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func search(query: String) async throws -> SearchResponse {
        let request = SearchRequest(query: query)
        return try await requestManager.perform(request)
    }
}

/// Request for search
struct SearchRequest: RequestProtocol {
    let host = "mock.apidog.com"
    let path: String
    let requestType: RequestType = .GET
    private(set) var urlParams = [String: String?]()
    
    init(query: String) {
        self.path = "/m1/735111-711675-default/search"
        self.urlParams["q"] = query.isEmpty ? nil : query
    }
}
