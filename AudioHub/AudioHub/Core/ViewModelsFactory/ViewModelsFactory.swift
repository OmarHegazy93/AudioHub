//
//  ViewModelsFactory.swift
//  AudioHub
//
//  Created by Omar Hegazy on 17/08/2025.
//

final class ViewModelsFactory {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }

    @MainActor
    func createHomeViewModel(coordinator: HomeCoordinator) -> HomeViewModel {
        HomeViewModel(api: HomeSectionsAPI(requestManager: requestManager), coordinator: coordinator)
    }
}
