import Foundation

/// Factory protocol for creating content items
protocol ContentItemFactory {
    func createContentItems<T: CodingKey>(from container: KeyedDecodingContainer<T>, contentType: ContentType, forKey key: T) throws -> [any ContentItem]
}

/// Implementation of content item factory
final class ContentItemFactoryImpl: ContentItemFactory {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func createContentItems<T: CodingKey>(from container: KeyedDecodingContainer<T>, contentType: ContentType, forKey key: T) throws -> [any ContentItem] {
        switch contentType {
        case .podcast:
            return try container.decode([PodcastItem].self, forKey: key)
        case .episode:
            return try container.decode([EpisodeItem].self, forKey: key)
        case .audioBook:
            return try container.decode([AudiobookItem].self, forKey: key)
        case .audioArticle:
            return try container.decode([AudioArticleItem].self, forKey: key)
        }
    }
}
