import Foundation

/// Section from search results
struct SearchSection: Codable, Identifiable {
    let id = UUID()
    let content: [SearchContentItem]
    let contentType: String
    let name: String
    let order: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case content
        case contentType = "content_type"
        case name
        case order
        case type
    }
    
    // Custom initializer for testing and direct creation
    init(
        content: [SearchContentItem],
        contentType: String,
        name: String,
        order: String,
        type: String
    ) {
        self.content = content
        self.contentType = contentType
        self.name = name
        self.order = order
        self.type = type
    }
}
