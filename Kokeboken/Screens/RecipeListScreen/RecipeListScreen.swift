import Assets
import SwiftData
import SwiftUI

struct RecipeListScreen: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @EnvironmentObject
    private var navigationCoordinator: NavigationCoordinator
    
    @StateObject
    private var viewModel = ViewModel()
    
    @State
    private var isPresentingSearch: Bool = false
    
    var body: some View {
        ScrollView {
            SearchableList(query: viewModel.query) { recipe in
                isPresentingSearch = false
                
                Task { @MainActor [recipe] in
                    try? await Task.sleep(for: .seconds(0.4))
                    navigationCoordinator.push(recipe)
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Oppskrifter")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    viewModel.showRecipeUrlDialog.toggle()
                }
                .alert(
                    "Lim inn lenke til oppskrift",
                    isPresented: $viewModel.showRecipeUrlDialog
                ) {
                    TextField("Lenke", text: $viewModel.recipeUrlText)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    Button("Avbryt", role: .cancel) {
                        viewModel.recipeUrlText = ""
                    }
                    
                    Button("Legg til") {
                        Task {
                            await viewModel.addRecipe(into: modelContext)
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Assets.Colors.background)
        .searchable(
            text: $viewModel.query,
            isPresented: $isPresentingSearch,
            prompt: "Søk etter oppskrift"
        )
        .toolbar {
            if viewModel.isAddingRecipe {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        
                    } label: {
                        Image(
                            systemName: viewModel.addRecipeSuccess ? "checkmark" : "circle.hexagonpath"
                        )
                        .symbolEffect(
                            .rotate.byLayer,
                            options: .repeat(.periodic(delay: 0.3)),
                            isActive: viewModel.addRecipeSuccess == false
                        )
                        .contentTransition(
                            .symbolEffect(
                                .replace.magic(
                                    fallback: .downUp.byLayer
                                ),
                                options: .nonRepeating
                            )
                        )
                        .foregroundStyle(.white)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Assets.Colors.primary)
                    .sensoryFeedback(.success, trigger: viewModel.addRecipeSuccess)
                }
            }
        }
        .onAppear {
            if viewModel.query.isEmpty == false {
                isPresentingSearch = true
            }
        }
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeReaderScreen(recipe: recipe)
        }
    }
}

fileprivate struct SearchableList: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Query
    private var recipes: [Recipe]
    
    let onTapRecipe: (Recipe) -> Void
    
    init(query: String, onTapRecipe: @escaping (Recipe) -> Void) {
        _recipes = Query(
            filter: #Predicate<Recipe> { recipe in
                query.isEmpty ||
                recipe.title.localizedStandardContains(query)
            },
            sort: \.title,
            animation: .snappy
        )
        
        self.onTapRecipe = onTapRecipe
    }
    
    var body: some View {
        LazyVStack {
            ForEach(recipes) { recipe in
                RecipeCard(recipe: recipe, onTap: onTapRecipe)
            }
        }
    }
}

#if DEBUG
#Preview {
    @Previewable
    @StateObject
    var navigationCoordinator = NavigationCoordinator()
    
    let mockedModelContainer = mockedModelContainer()
    
    NavigationStack(path: $navigationCoordinator.path) {
        RecipeListScreen()
    }
    .modelContainer(mockedModelContainer)
    .environmentObject(navigationCoordinator)
    .task {
        await Recipe.injectMockedList(into: mockedModelContainer.mainContext)
    }
}
#endif
