import SwiftUI

/// Strategy protocol for rendering different content types
protocol ContentRenderingStrategy {
    associatedtype Content: View
    func render(content: [any ContentItem], sectionName: String) -> Content
}

/// Podcast rendering strategy
struct PodcastRenderingStrategy: ContentRenderingStrategy {
    func render(content: [any ContentItem], sectionName: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(sectionName)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(content, id: \.id) { item in
                        if let podcast = item as? PodcastItem {
                            PodcastItemView(podcast: podcast)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

/// Episode rendering strategy
struct EpisodeRenderingStrategy: ContentRenderingStrategy {
    func render(content: [any ContentItem], sectionName: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(sectionName)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(content, id: \.id) { item in
                    if let episode = item as? EpisodeItem {
                        EpisodeItemView(episode: episode)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

/// Audiobook rendering strategy
struct AudiobookRenderingStrategy: ContentRenderingStrategy {
    func render(content: [any ContentItem], sectionName: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(sectionName)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(content, id: \.id) { item in
                    if let audiobook = item as? AudiobookItem {
                        AudiobookItemView(audiobook: audiobook)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

/// Audio Article rendering strategy
struct AudioArticleRenderingStrategy: ContentRenderingStrategy {
    func render(content: [any ContentItem], sectionName: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(sectionName)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(content, id: \.id) { item in
                    if let article = item as? AudioArticleItem {
                        AudioArticleItemView(article: article)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

/// Factory for creating rendering strategies
struct RenderingStrategyFactory {
    static func createStrategy(for contentType: ContentType) -> any ContentRenderingStrategy {
        switch contentType {
        case .podcast:
            return PodcastRenderingStrategy()
        case .episode:
            return EpisodeRenderingStrategy()
        case .audioBook:
            return AudiobookRenderingStrategy()
        case .audioArticle:
            return AudioArticleRenderingStrategy()
        }
    }
}
