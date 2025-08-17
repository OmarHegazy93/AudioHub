import SwiftUI

struct SearchSectionView: View {
    let section: SearchSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack {
                Text(section.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(section.contentType)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Content items
            LazyVStack(spacing: 8) {
                ForEach(section.content) { item in
                    SearchContentItemView(item: item)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    let sampleItem = SearchContentItem(
        avatarURL: "https://example.com/avatar.jpg",
        description: "Sample description",
        duration: "3600",
        episodeCount: "10",
        language: "English",
        name: "Sample Podcast",
        podcastId: "123",
        popularityScore: "85",
        priority: "high",
        score: "0.95"
    )
    
    let sampleSection = SearchSection(
        content: [sampleItem],
        contentType: "podcast",
        name: "Search Results",
        order: "1",
        type: "grid"
    )
    
    return SearchSectionView(section: sampleSection)
        .padding()
        .background(Color(.systemGroupedBackground))
}
