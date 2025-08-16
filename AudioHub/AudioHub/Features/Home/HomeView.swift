import SwiftUI

struct HomeView: View {
    @State var coordinator: AppCoordinator
    @State private var viewModel = HomeViewModel()
    
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
                
                // Content based on state
                if viewModel.isLoading {
                    ProgressView("Loading sections...")
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Error loading sections")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 200)
                } else if viewModel.sections.isEmpty {
                    Text("No sections available")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    // Render all sections
                    LazyVStack(spacing: 24) {
                        ForEach(viewModel.sections) { section in
                            SectionView(section: section)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadHomeSections()
        }
    }
}

#Preview {
    HomeView(coordinator: AppCoordinator())
}
