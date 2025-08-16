//
//  ContentView.swift
//  AudioHub
//
//  Created by Omar Hegazy on 16/08/2025.
//

import SwiftUI

struct CoordinatorView: View {
    @State var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            coordinator.view(for: .home)
                .navigationDestination(for: AppDestination.self) { destination in
                    coordinator.view(for: destination)
                }
        }
    }
}


#Preview {
    CoordinatorView()
}
