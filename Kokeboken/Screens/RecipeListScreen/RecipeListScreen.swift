import Assets
import SwiftData
import SwiftUI

struct RecipeListScreen: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Query(animation: .snappy)
    private var recipes: [Recipe]
    
    @StateObject
    private var viewModel = ViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(recipes) { recipe in
                    Text(recipe.title)
                        .transition(.offset(x: 0, y: -20).combined(with: .opacity))
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
    }
}

#Preview {
    NavigationStack {
        RecipeListScreen()
    }
    .modelContainer(mockedModelContainer())
}
