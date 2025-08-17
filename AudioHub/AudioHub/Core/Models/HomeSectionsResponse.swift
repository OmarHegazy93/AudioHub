import Foundation

/// Response from the home sections API endpoint
struct HomeSectionsResponse: Codable {
    let sections: [HomeSection]
    let pagination: Pagination
    
    // Custom initializer for testing
    init(sections: [HomeSection], pagination: Pagination) {
        self.sections = sections
        self.pagination = pagination
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode sections
        do {
            sections = try container.decode([HomeSection].self, forKey: .sections)
        } catch {
            print("❌ Failed to decode sections: \(error)")
            throw error
        }
        
        // Decode pagination
        pagination = try container.decode(Pagination.self, forKey: .pagination)
    }
}

/// Pagination information for the API response
struct Pagination: Codable {
    let nextPage: String?
    let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case nextPage = "next_page"
        case totalPages = "total_pages"
    }
    
    // Custom initializer for testing
    init(nextPage: String?, totalPages: Int?) {
        self.nextPage = nextPage
        self.totalPages = totalPages
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Make both fields optional since they might not exist
        nextPage = try container.decodeIfPresent(String.self, forKey: .nextPage)
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
    }
}
