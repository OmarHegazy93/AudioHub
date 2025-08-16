import Foundation

/// Response from the home sections API endpoint
struct HomeSectionsResponse: Codable {
    let sections: [HomeSection]
    let pagination: Pagination
}

/// Pagination information for the API response
struct Pagination: Codable {
    let nextPage: String?
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case nextPage = "next_page"
        case totalPages = "total_pages"
    }
}
