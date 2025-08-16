import Foundation

/// Represents a content item that can be a podcast, episode, audiobook, or audio article
struct ContentItem: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let avatarURL: String
    let duration: Int
    let score: Double
    
    // Podcast specific properties
    let podcastID: String?
    let episodeCount: Int?
    let language: String?
    let priority: Int?
    let popularityScore: Int?
    
    // Episode specific properties
    let episodeID: String?
    let seasonNumber: Int?
    let episodeType: String?
    let podcastName: String?
    let authorName: String?
    let number: Int?
    let audioURL: String?
    let separatedAudioURL: String?
    let releaseDate: String?
    let podcastPopularityScore: Int?
    let podcastPriority: Int?
    
    // Audiobook specific properties
    let audiobookID: String?
    
    // Audio article specific properties
    let articleID: String?
    enum CodingKeys: String, CodingKey {
        case id = "podcast_id"
        case name, description, avatarURL = "avatar_url", duration, score
        case podcastID = "podcast_id"
        case episodeCount = "episode_count"
        case language, priority, popularityScore = "popularityScore"
        case episodeID = "episode_id"
        case seasonNumber = "season_number"
        case episodeType = "episode_type"
        case podcastName = "podcast_name"
        case authorName = "author_name"
        case number, audioURL = "audio_url"
        case separatedAudioURL = "separated_audio_url"
        case releaseDate = "release_date"
        case podcastPopularityScore = "podcastPopularityScore"
        case podcastPriority = "podcastPriority"
        case audiobookID = "audiobook_id"
        case articleID = "article_id"
    }
    
    // Computed properties for type-specific access
    var isPodcast: Bool { podcastID != nil && episodeCount != nil }
    var isEpisode: Bool { episodeID != nil && podcastName != nil }
    var isAudiobook: Bool { audiobookID != nil }
    var isAudioArticle: Bool { articleID != nil }
}
