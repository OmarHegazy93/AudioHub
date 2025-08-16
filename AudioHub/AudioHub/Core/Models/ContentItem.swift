import Foundation

/// Base protocol for all content items
protocol ContentItem: Codable, Identifiable {
    var id: String { get }
    var name: String { get }
    var description: String { get }
    var avatarURL: String { get }
    var duration: Int { get }
    var score: Double { get }
}

/// Podcast content item
struct PodcastItem: ContentItem {
    let id: String
    let name: String
    let description: String
    let avatarURL: String
    let duration: Int
    let score: Double
    
    // Podcast-specific properties
    let episodeCount: Int
    let language: String?
    let priority: Int?
    let popularityScore: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "podcast_id"
        case name, description, avatarURL = "avatar_url", duration, score
        case episodeCount = "episode_count"
        case language, priority, popularityScore = "popularityScore"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        avatarURL = try container.decode(String.self, forKey: .avatarURL)
        duration = try container.decode(Int.self, forKey: .duration)
        score = try container.decode(Double.self, forKey: .score)
        episodeCount = try container.decode(Int.self, forKey: .episodeCount)
        
        // Make optional fields truly optional with defaults
        language = try container.decodeIfPresent(String.self, forKey: .language) ?? "en"
        priority = try container.decodeIfPresent(Int.self, forKey: .priority) ?? 0
        popularityScore = try container.decodeIfPresent(Int.self, forKey: .popularityScore) ?? 0
    }
}

/// Episode content item
struct EpisodeItem: ContentItem {
    let id: String
    let name: String
    let description: String
    let avatarURL: String
    let duration: Int
    let score: Double
    
    // Episode-specific properties
    let seasonNumber: Int?
    let episodeType: String
    let podcastName: String
    let authorName: String
    let number: Int?
    let audioURL: String
    let separatedAudioURL: String
    let releaseDate: String
    let podcastPopularityScore: Int
    let podcastPriority: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "episode_id"
        case name, description, avatarURL = "avatar_url", duration, score
        case seasonNumber = "season_number"
        case episodeType = "episode_type"
        case podcastName = "podcast_name"
        case authorName = "author_name"
        case number, audioURL = "audio_url"
        case separatedAudioURL = "separated_audio_url"
        case releaseDate = "release_date"
        case podcastPopularityScore = "podcastPopularityScore"
        case podcastPriority = "podcastPriority"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        avatarURL = try container.decode(String.self, forKey: .avatarURL)
        duration = try container.decode(Int.self, forKey: .duration)
        score = try container.decode(Double.self, forKey: .score)
        
        // Handle optional fields with defaults
        seasonNumber = try container.decodeIfPresent(Int.self, forKey: .seasonNumber)
        episodeType = try container.decode(String.self, forKey: .episodeType)
        podcastName = try container.decode(String.self, forKey: .podcastName)
        authorName = try container.decodeIfPresent(String.self, forKey: .authorName) ?? ""
        number = try container.decodeIfPresent(Int.self, forKey: .number)
        audioURL = try container.decode(String.self, forKey: .audioURL)
        separatedAudioURL = try container.decodeIfPresent(String.self, forKey: .separatedAudioURL) ?? ""
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        podcastPopularityScore = try container.decode(Int.self, forKey: .podcastPopularityScore)
        podcastPriority = try container.decode(Int.self, forKey: .podcastPriority)
    }
}

/// Audiobook content item
struct AudiobookItem: ContentItem {
    let id: String
    let name: String
    let description: String
    let avatarURL: String
    let duration: Int
    let score: Double
    
    // Audiobook-specific properties
    let authorName: String
    let language: String?
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id = "audiobook_id"
        case name, description, avatarURL = "avatar_url", duration, score
        case authorName = "author_name"
        case language, releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        avatarURL = try container.decode(String.self, forKey: .avatarURL)
        duration = try container.decode(Int.self, forKey: .duration)
        score = try container.decode(Double.self, forKey: .score)
        authorName = try container.decode(String.self, forKey: .authorName)
        
        // Make language optional with default
        language = try container.decodeIfPresent(String.self, forKey: .language) ?? "en"
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
}

/// Audio article content item
struct AudioArticleItem: ContentItem {
    let id: String
    let name: String
    let description: String
    let avatarURL: String
    let duration: Int
    let score: Double
    
    // Audio article-specific properties
    let authorName: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id = "article_id"
        case name, description, avatarURL = "avatar_url", duration, score
        case authorName = "author_name"
        case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        avatarURL = try container.decode(String.self, forKey: .avatarURL)
        duration = try container.decode(Int.self, forKey: .duration)
        score = try container.decode(Double.self, forKey: .score)
        authorName = try container.decode(String.self, forKey: .authorName)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
}
