import SwiftUI

/// Strategy protocol for rendering different content types
protocol ContentRenderingStrategy {
    associatedtype Content: View
    func render(content: [any ContentItem], sectionName: String) -> Content
}

/// Generic view for rendering any content item
struct ContentItemView: View {
    let item: any ContentItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Content image
            AsyncImage(url: URL(string: item.avatarURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: iconName)
                            .foregroundColor(.gray)
                    )
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Content info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(item.description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(formatDuration(item.duration))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var iconName: String {
        switch item {
        case is PodcastItem:
            return "mic"
        case is EpisodeItem:
            return "play.circle"
        case is AudiobookItem:
            return "book"
        case is AudioArticleItem:
            return "doc.text"
        default:
            return "play"
        }
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes) min"
        }
    }
}

/// Queue rendering strategy - vertical list layout
struct QueueRenderingStrategy: ContentRenderingStrategy {
    func render(content: [any ContentItem], sectionName: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(sectionName)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(content, id: \.id) { item in
                        ContentItemView(item: item)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

/// Big square rendering strategy - large featured items
struct BigSquareRenderingStrategy: ContentRenderingStrategy {
    func render(content: [any ContentItem], sectionName: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(sectionName)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(content, id: \.id) { item in
                        ContentItemView(item: item)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

/// Square rendering strategy - medium-sized grid items
struct SquareRenderingStrategy: ContentRenderingStrategy {
    func render(content: [any ContentItem], sectionName: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(sectionName)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(content, id: \.id) { item in
                        ContentItemView(item: item)
                            .frame(width: UIScreen.main.bounds.width * 0.4)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

/// Two lines grid rendering strategy - horizontal scrolling with two rows
struct TwoLinesGridRenderingStrategy: ContentRenderingStrategy {
    private let screenWidth = UIScreen.main.bounds.width
    
    func render(content: [any ContentItem], sectionName: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(sectionName)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(content, id: \.id) { item in
                        ContentItemView(item: item)
                            .frame(width: screenWidth * 0.8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

/// Binary grid rendering strategy - two-column vertical grid
struct BinaryGridRenderingStrategy: ContentRenderingStrategy {
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
                    ContentItemView(item: item)
                }
            }
            .padding(.horizontal)
        }
    }
}

/// Factory for creating rendering strategies based on section type
struct RenderingStrategyFactory {
    static func createStrategy(for sectionType: SectionType) -> any ContentRenderingStrategy {
        switch sectionType {
        case .queue:
            return QueueRenderingStrategy()
        case .bigSquare:
            return BigSquareRenderingStrategy()
        case .square:
            return SquareRenderingStrategy()
        case .twoLinesGrid:
            return TwoLinesGridRenderingStrategy()
        case .binaryGrid:
            return BinaryGridRenderingStrategy()
        }
    }
}
