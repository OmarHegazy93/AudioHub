//
//  AudioHubApp.swift
//  AudioHub
//
//  Created by Omar Hegazy on 16/08/2025.
//

import SwiftUI

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

@main
struct MainEntryPoint {
    static func main() {
        guard isProduction() else {
            TestApp.main()
            return
        }
 
        AudioHubApp.main()
    }
 
    private static func isProduction() -> Bool {
        return NSClassFromString("XCTestCase") == nil
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup {
        }
    }
}
