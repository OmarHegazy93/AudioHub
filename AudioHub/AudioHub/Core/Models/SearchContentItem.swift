import Foundation

/// Content item from search results
struct SearchContentItem: Codable, Identifiable {
    let id = UUID()
    let avatarURL: String
    let description: String
    let duration: String
    let episodeCount: String
    let language: String
    let name: String
    let podcastId: String
    let popularityScore: String
    let priority: String
    let score: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case description
        case duration
        case episodeCount = "episode_count"
        case language
        case name
        case podcastId = "podcast_id"
        case popularityScore = "popularityScore"
        case priority
        case score
    }
    
    // Custom initializer for testing and direct creation
    init(
        avatarURL: String,
        description: String,
        duration: String,
        episodeCount: String,
        language: String,
        name: String,
        podcastId: String,
        popularityScore: String,
        priority: String,
        score: String
    ) {
        self.avatarURL = avatarURL
        self.description = description
        self.duration = duration
        self.episodeCount = episodeCount
        self.language = language
        self.name = name
        self.podcastId = podcastId
        self.popularityScore = popularityScore
        self.priority = priority
        self.score = score
    }
}
