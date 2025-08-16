//
//  DataParserProtocol.swift
//  AudioHub
//
//  Created by Omar Hegazy on 16/08/2025.
//

import Foundation

/// Protocol defining the Data Parser
protocol DataParserProtocol {
    /// Parses the given data into a Decodable object
    /// - Parameter data: The data to be parsed
    /// - Returns: A result containing either the decoded object or a parsing error
    func parse<T: Decodable>(_ data: Data) throws -> T
}

/// Implementation of the Data Parser conforming to `DataParserProtocol`
final class DataParser: DataParserProtocol {
    /// The JSON decoder used for decoding data
    private let decoder: JSONDecoder
    
    /// Initializer with dependency injection for JSONDecoder
    /// - Parameter decoder: The JSON decoder to use, defaults to `JSONDecoder` with standard decoding strategy
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
        // Remove snake case conversion to avoid conflicts with CodingKeys
        // self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func parse<T: Decodable>(_ data: Data) throws -> T {
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            print("❌ DataParser: error occurred while decoding data: \(error.localizedDescription)")
            throw ParsingError.invalidData(error)
        }
    }
}
