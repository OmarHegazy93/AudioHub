import SwiftUI

// MARK: - Podcast Item View
struct PodcastItemView: View {
    let podcast: PodcastItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Podcast image
            AsyncImage(url: URL(string: podcast.avatarURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "mic")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Podcast info
            VStack(alignment: .leading, spacing: 4) {
                Text(podcast.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text("\(podcast.episodeCount) episodes")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(width: 120)
        }
    }
}

// MARK: - Episode Item View
struct EpisodeItemView: View {
    let episode: EpisodeItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Episode image
            AsyncImage(url: URL(string: episode.avatarURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "play.circle")
                            .foregroundColor(.gray)
                    )
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Episode info
            VStack(alignment: .leading, spacing: 4) {
                Text(episode.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(episode.podcastName)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(formatDuration(episode.duration))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        return "\(minutes) min"
    }
}

// MARK: - Audiobook Item View
struct AudiobookItemView: View {
    let audiobook: AudiobookItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Audiobook image
            AsyncImage(url: URL(string: audiobook.avatarURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "book")
                            .foregroundColor(.gray)
                    )
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Audiobook info
            VStack(alignment: .leading, spacing: 4) {
                Text(audiobook.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(audiobook.authorName)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(formatDuration(audiobook.duration))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}

// MARK: - Audio Article Item View
struct AudioArticleItemView: View {
    let article: AudioArticleItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Article image
            AsyncImage(url: URL(string: article.avatarURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "doc.text")
                            .foregroundColor(.gray)
                    )
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Article info
            VStack(alignment: .leading, spacing: 4) {
                Text(article.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(article.authorName)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(formatDuration(article.duration))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        return "\(minutes) min"
    }
}
