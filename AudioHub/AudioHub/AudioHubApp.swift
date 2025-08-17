//
//  AudioHubApp.swift
//  AudioHub
//
//  Created by Omar Hegazy on 16/08/2025.
//

import SwiftUI

@main
struct AudioHubApp: App {
    let coordinator: AppCoordinator

    init() {
        let requestManager = RequestManager()
        let viewModelsFactory = ViewModelsFactory(requestManager: requestManager)
        self.coordinator = AppCoordinator(viewModelsFactory: viewModelsFactory)
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: coordinator)
        }
    }
}
