import SwiftUI

struct SearchContentItemView: View {
    let item: SearchContentItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Avatar
            AsyncImage(url: URL(string: item.avatarURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.secondary.opacity(0.2))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.secondary)
                    )
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Content details
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(item.score)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                }
                
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                VStack(alignment: .leading, spacing: 12) {
                    // Duration
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text(formatDuration(item.duration))
                            .font(.caption2)
                    }
                    .foregroundColor(.secondary)
                    
                    // Episode count
                    HStack(spacing: 4) {
                        Image(systemName: "number")
                            .font(.caption2)
                        Text("\(item.episodeCount) episodes")
                            .font(.caption2)
                    }
                    .foregroundColor(.secondary)
                    
                    // Language
                    HStack(spacing: 4) {
                        Image(systemName: "globe")
                            .font(.caption2)
                        Text(item.language)
                            .font(.caption2)
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    private func formatDuration(_ durationString: String) -> String {
        guard let duration = Int(durationString) else { return "Unknown" }
        
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

#Preview {
    let sampleItem = SearchContentItem(
        avatarURL: "https://avatars.githubusercontent.com/u/19925926",
        description: "Andy shoes are designed to keeping in mind durability as well as trends, the most stylish range of shoes & sandals",
        duration: "53198",
        episodeCount: "3",
        language: "English",
        name: "Refined Fresh Shoes",
        podcastId: "9d46658a-cb07-4e2f-9def-d1df7bcadd9c",
        popularityScore: "85",
        priority: "high",
        score: "0.95"
    )
    
    return SearchContentItemView(item: sampleItem)
        .padding()
        .background(Color(.systemGroupedBackground))
}
