import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search header
            HStack {
                Button("Back") {
                    viewModel.goToHome()
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
            .padding(.top)
            
            // Search text field
            HStack {
                TextField("Search podcasts, episodes, audiobooks...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: viewModel.searchText) { _, _ in
                        viewModel.searchTextChanged()
                    }
                    .onSubmit {
                        Task {
                            await viewModel.performSearch()
                        }
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button("Search") {
                        Task {
                            await viewModel.performSearch()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Search results or placeholder
            if viewModel.isLoading {
                ProgressView("Searching...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    
                    Text("Search Error")
                        .font(.headline)
                    
                    Text(errorMessage)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Try Again") {
                        Task {
                            await viewModel.performSearch()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.hasSearched && viewModel.searchResults.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    
                    Text("No Results Found")
                        .font(.headline)
                    
                    Text("Try adjusting your search terms or browse our content categories.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !viewModel.searchResults.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.searchResults) { section in
                            SearchSectionView(section: section)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
            } else {
                // Initial state
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    
                    Text("Search for Content")
                        .font(.headline)
                    
                    Text("Enter keywords to find podcasts, episodes, audiobooks, and more.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(searchAPI: SearchAPI(), coordinator: AppCoordinator(viewModelsFactory: ViewModelsFactory(requestManager: RequestManager()))))
}
