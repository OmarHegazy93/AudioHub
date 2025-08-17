import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack {
            // Search header
            HStack {
                Button("Back") {
                    coordinator.navigateToHome()
                }
                
                Spacer()
                
                Text("Search")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Invisible button for balance
                Button("") { }
                    .opacity(0)
            }
            .padding(.horizontal)
            
            // Search text field
            TextField("Search podcasts, episodes, audiobooks...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Placeholder for search results
            Text("Search results will be displayed here")
                .foregroundColor(.secondary)
                .padding()
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SearchView(coordinator: AppCoordinator(viewModelsFactory: ViewModelsFactory(requestManager: RequestManager())))
}
