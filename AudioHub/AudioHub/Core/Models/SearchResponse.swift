import Foundation

/// Response from the search API endpoint
struct SearchResponse: Codable {
    let sections: [SearchSection]
}
