import SwiftUI

/// Protocol for search navigation
@MainActor
protocol SearchNavigation {
    func navigateToSearch()
}

/// Protocol for home navigation
@MainActor
protocol HomeNavigation {
    func navigateToHome()
    func resetToHome()
}

/// Coordinator for managing navigation in the AudioHub app
@MainActor
@Observable
final class AppCoordinator: SearchNavigation, HomeNavigation {
    var navigationPath = NavigationPath()
    
    /// Navigate to the search screen
    func navigateToSearch() {
        navigationPath.append(AppDestination.search)
    }
    
    /// Navigate back to home screen
    func navigateToHome() {
        navigationPath.removeLast()
    }
    
    /// Reset navigation to home
    func resetToHome() {
        navigationPath.removeLast(navigationPath.count)
    }

    @ViewBuilder
    func view(for destination: AppDestination) -> some View {
        switch destination {
        case .home:
            HomeView(coordinator: self)
        case .search:
            SearchView(coordinator: self)
        }
    }
}
