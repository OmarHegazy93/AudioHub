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
                        
                        // Next page loading indicator
                        if viewModel.isLoadingNextPage {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Loading more...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                        
                        // Load more trigger view
                        if viewModel.hasMorePages && !viewModel.isLoadingNextPage {
                            Color.clear
                                .frame(height: 1)
                                .onAppear {
                                    Task {
                                        await viewModel.loadNextPage()
                                    }
                                }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadHomeSections()
        }
    }
}

#Preview {
    HomeView(coordinator: AppCoordinator())
}
