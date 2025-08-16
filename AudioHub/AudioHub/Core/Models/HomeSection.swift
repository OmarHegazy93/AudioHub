import Foundation

/// Represents a section on the home screen
struct HomeSection: Codable, Identifiable {
    let id = UUID()
    let name: String
    let type: SectionType
    let contentType: ContentType
    let order: Int
    let content: [ContentItem]
    
    enum CodingKeys: String, CodingKey {
        case name, type, contentType = "content_type", order, content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        contentType = try container.decode(ContentType.self, forKey: .contentType)
        order = try container.decode(Int.self, forKey: .order)
        content = try container.decode([ContentItem].self, forKey: .content)
        
        // Handle both "big_square" and "big square" for the type
        let typeString = try container.decode(String.self, forKey: .type)
        switch typeString {
        case "big_square", "big square":
            type = .bigSquare
        case "queue":
            type = .queue
        case "square":
            type = .square
        case "2_lines_grid":
            type = .twoLinesGrid
        case "binary_grid":
            type = .binaryGrid
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown section type: \(typeString)")
        }
    }
}

/// Types of sections that can be displayed
enum SectionType: String, Codable {
    case queue = "queue"
    case bigSquare = "big_square"
    case square = "square"
    case twoLinesGrid = "2_lines_grid"
    case binaryGrid = "binary_grid"
}

/// Types of content that can be displayed
enum ContentType: String, Codable {
    case podcast = "podcast"
    case episode = "episode"
    case audioBook = "audio_book"
    case audioArticle = "audio_article"
}
