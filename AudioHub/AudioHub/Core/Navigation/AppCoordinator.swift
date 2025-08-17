import SwiftUI

/// Coordinator for managing navigation in the AudioHub app
@MainActor
@Observable
final class AppCoordinator: HomeCoordinator, SearchCoordinator {
    private let viewModelsFactory: ViewModelsFactory
    var navigationPath = NavigationPath()

    init(viewModelsFactory: ViewModelsFactory) {
        self.viewModelsFactory = viewModelsFactory
    }
    
    /// Navigate to the search screen
    func navigateToSearch() {
        navigationPath.append(AppDestination.search)
    }
    
    /// Navigate back to home screen
    func navigateToHome() {
        navigationPath.removeLast()
    }

    @ViewBuilder
    func view(for destination: AppDestination) -> some View {
        switch destination {
        case .home:
            HomeView(viewModel: viewModelsFactory.createHomeViewModel(coordinator: self))
        case .search:
            SearchView(viewModel: viewModelsFactory.createSearchViewModel(coordinator: self))
        }
    }
}
