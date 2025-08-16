//
//  RequestManagerProtocol.swift
//  AudioHub
//
//  Created by Omar Hegazy on 16/08/2025.
//

/// Protocol defining the Request Manager
public protocol RequestManagerProtocol {
    /// Performs a network request and parses the response
    /// - Parameters:
    ///   - request: The request to be performed, conforming to `RequestProtocol`
    /// - Returns: result containing either a decoded object or a request error
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}

/// Implementation of the Request Manager conforming to `RequestManagerProtocol`
final class RequestManager: RequestManagerProtocol {
    /// The API manager used to perform network requests
    private let apiManager: APIManagerProtocol
    /// The data parser used to parse the response data
    private let parser: DataParserProtocol
    
    public static let shared = RequestManager()
    
    /// Initializer with dependency injection for APIManager and DataParser
    /// - Parameters:
    ///   - apiManager: The API manager to use, defaults to `APIManager`
    ///   - parser: The data parser to use, defaults to `DataParser`
    init(
        apiManager: APIManagerProtocol = APIManager(),
        parser: DataParserProtocol = DataParser()
    ) {
        self.apiManager = apiManager
        self.parser = parser
    }
    
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        // Perform the network request using the API manager
        let data = try await apiManager.perform(request)
        return try parser.parse(data)
    }
}
