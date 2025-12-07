import Assets
import SwiftData
import SwiftUI

struct RecipeListScreen: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @StateObject
    private var viewModel = ViewModel()
    
    @State
    var query: String = ""
    
    var body: some View {
        ScrollView {
            SearchableList(query: viewModel.query)
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
        .searchable(text: $viewModel.query, prompt: "Søk etter oppskrift")
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
        .navigationDestination(for: Recipe.self) { recipe in
            return RecipeReaderScreen(recipe: recipe)
        }
    }
}

fileprivate struct SearchableList: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Query
    private var recipes: [Recipe]
    
    init(query: String) {
        _recipes = Query(
            filter: #Predicate<Recipe> { recipe in
                query.isEmpty ||
                recipe.title.localizedStandardContains(query)
            },
            sort: \.title,
            animation: .snappy
        )
    }
    
    var body: some View {
        LazyVStack {
            ForEach(recipes) { recipe in
                RecipeCard(recipe: recipe)
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
    
    NavigationStack {
        RecipeListScreen()
    }
    .modelContainer(mockedModelContainer)
    .environmentObject(navigationCoordinator)
    .task {
        await Recipe.injectMockedList(into: mockedModelContainer.mainContext)
    }
}
#endif
