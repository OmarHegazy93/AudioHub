import SwiftUI

struct HomeView: View {
    @State var coordinator: AppCoordinator
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with search button
                HStack {
                    Text("AudioHub")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        coordinator.navigateToSearch()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                // Placeholder for sections
                Text("Home sections will be displayed here")
                    .foregroundColor(.secondary)
                    .padding()
                
                Spacer()
            }
        }
       .navigationBarHidden(true)
    }
}

#Preview {
    HomeView(coordinator: AppCoordinator())
}
