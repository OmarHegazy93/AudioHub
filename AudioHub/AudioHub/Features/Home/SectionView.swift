import SwiftUI

struct SectionView: View {
    let section: HomeSection
    
    var body: some View {
        // Use the rendering strategy pattern for better maintainability
        let strategy = RenderingStrategyFactory.createStrategy(for: section.type)
        AnyView(strategy.render(content: section.content, sectionName: section.name))
    }
}
