import Foundation

// /// Wrapper for content items that matches the API response structure
// struct ContentItemData: Codable {
//     // Common fields
//     let name: String
//     let description: String
//     let avatar_url: String
//     let duration: Int
//     let score: Double
    
//     // Podcast-specific fields
//     let podcast_id: String?
//     let episode_count: Int?
//     let language: String?
//     let priority: Int?
//     let popularityScore: Int?
    
//     // Episode-specific fields
//     let episode_id: String?
//     let season_number: Int?
//     let episode_type: String?
//     let podcast_name: String?
//     let author_name: String?
//     let number: Int?
//     let audio_url: String?
//     let separated_audio_url: String?
//     let release_date: String?
//     let podcastPopularityScore: Int?
//     let podcastPriority: Int?
    
//     // Audiobook-specific fields
//     let audiobook_id: String?
    
//     // Article-specific fields
//     let article_id: String?
    
//     // Coding keys to handle optional fields
//     enum CodingKeys: String, CodingKey {
//         case name, description, avatar_url, duration, score
//         case podcast_id, episode_count, language, priority, popularityScore
//         case episode_id, season_number, episode_type, podcast_name, author_name
//         case number, audio_url, separated_audio_url, release_date
//         case podcastPopularityScore, podcastPriority
//         case audiobook_id, article_id
//     }
    
//     init(from decoder: Decoder) throws {
//         let container = try decoder.container(keyedBy: CodingKeys.self)
        
//         // Decode common fields
//         name = try container.decode(String.self, forKey: .name)
//         description = try container.decode(String.self, forKey: .description)
//         avatar_url = try container.decode(String.self, forKey: .avatar_url)
//         duration = try container.decode(Int.self, forKey: .duration)
//         score = try container.decode(Double.self, forKey: .score)
        
//         // Decode optional fields with default values
//         podcast_id = try container.decodeIfPresent(String.self, forKey: .podcast_id)
//         episode_count = try container.decodeIfPresent(Int.self, forKey: .episode_count)
//         language = try container.decodeIfPresent(String.self, forKey: .language)
//         priority = try container.decodeIfPresent(Int.self, forKey: .priority)
//         popularityScore = try container.decodeIfPresent(Int.self, forKey: .popularityScore)
        
//         episode_id = try container.decodeIfPresent(String.self, forKey: .episode_id)
//         season_number = try container.decodeIfPresent(Int.self, forKey: .season_number)
//         episode_type = try container.decodeIfPresent(String.self, forKey: .episode_type)
//         podcast_name = try container.decodeIfPresent(String.self, forKey: .podcast_name)
//         author_name = try container.decodeIfPresent(String.self, forKey: .author_name)
//         number = try container.decodeIfPresent(Int.self, forKey: .number)
//         audio_url = try container.decodeIfPresent(String.self, forKey: .audio_url)
//         separated_audio_url = try container.decodeIfPresent(String.self, forKey: .separated_audio_url)
//         release_date = try container.decodeIfPresent(String.self, forKey: .release_date)
//         podcastPopularityScore = try container.decodeIfPresent(Int.self, forKey: .podcastPopularityScore)
//         podcastPriority = try container.decodeIfPresent(Int.self, forKey: .podcastPriority)
        
//         audiobook_id = try container.decodeIfPresent(String.self, forKey: .audiobook_id)
//         article_id = try container.decodeIfPresent(String.self, forKey: .article_id)
//     }
// }
