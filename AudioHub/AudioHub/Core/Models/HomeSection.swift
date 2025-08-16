import Foundation

/// Represents a section on the home screen
struct HomeSection: Codable, Identifiable {
    let id = UUID()
    let name: String
    let type: SectionType
    let contentType: ContentType
    let order: Int
    let content: [any ContentItem]
    
    enum CodingKeys: String, CodingKey {
        case name, type, contentType = "content_type", order, content
    }
    
    // Custom initializer to avoid automatic Codable synthesis
    init(name: String, type: SectionType, contentType: ContentType, order: Int, content: [any ContentItem]) {
        self.name = name
        self.type = type
        self.contentType = contentType
        self.order = order
        self.content = content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        order = try container.decode(Int.self, forKey: .order)
        
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
        
        // Decode content_type
        let contentTypeString = try container.decode(String.self, forKey: .contentType)
        
        // Parse the content type
        guard let parsedContentType = ContentType(rawValue: contentTypeString) else {
            throw DecodingError.dataCorruptedError(forKey: .contentType, in: container, debugDescription: "Unknown content type: \(contentTypeString)")
        }
        contentType = parsedContentType
        
        // Use ContentItemFactory to decode content based on the content type
        let factory = ContentItemFactoryImpl()
        do {
            // Decode content using the factory pattern for better testability
            content = try factory.createContentItems(
                from: container,
                contentType: contentType,
                forKey: .content
            )
        } catch {
            print("❌ Failed to decode content for section '\(name)': \(error)")
            content = []
        }
    }
    
    /// Custom encoding to handle any ContentItem
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(contentType, forKey: .contentType)
        try container.encode(order, forKey: .order)
        
        // Encode content using the factory pattern for consistency
        let factory = ContentItemFactoryImpl()
        let contentData = try JSONSerialization.data(withJSONObject: content.map { item in
            // Basic properties that all content items share
            var dict: [String: Any] = [
                "id": item.id,
                "name": item.name,
                "description": item.description,
                "avatar_url": item.avatarURL,
                "duration": item.duration,
                "score": item.score
            ]
            
            // Add type-specific properties using a more maintainable approach
            switch contentType {
            case .podcast:
                if let podcast = item as? PodcastItem {
                    dict["episode_count"] = podcast.episodeCount
                    dict["language"] = podcast.language
                    dict["priority"] = podcast.priority
                    dict["popularityScore"] = podcast.popularityScore
                }
            case .episode:
                if let episode = item as? EpisodeItem {
                    dict["episode_id"] = episode.id
                    dict["season_number"] = episode.seasonNumber
                    dict["episode_type"] = episode.episodeType
                    dict["podcast_name"] = episode.podcastName
                    dict["author_name"] = episode.authorName
                    dict["number"] = episode.number
                    dict["audio_url"] = episode.audioURL
                    dict["separated_audio_url"] = episode.separatedAudioURL
                    dict["release_date"] = episode.releaseDate
                    dict["podcastPopularityScore"] = episode.podcastPopularityScore
                    dict["podcastPriority"] = episode.podcastPriority
                }
            case .audioBook:
                if let audiobook = item as? AudiobookItem {
                    dict["audiobook_id"] = audiobook.id
                    dict["author_name"] = audiobook.authorName
                    dict["language"] = audiobook.language
                    dict["release_date"] = audiobook.releaseDate
                }
            case .audioArticle:
                if let article = item as? AudioArticleItem {
                    dict["article_id"] = article.id
                    dict["author_name"] = article.authorName
                    dict["release_date"] = article.releaseDate
                }
            }
            
            return dict
        })
        
        try container.encode(contentData, forKey: .content)
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
enum ContentType: String, Codable, CaseIterable {
    case podcast = "podcast"
    case episode = "episode"
    case audioBook = "audio_book"
    case audioArticle = "audio_article"
}
