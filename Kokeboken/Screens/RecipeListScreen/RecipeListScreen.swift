import Assets
import SwiftUI

struct RecipeListScreen: View {
    @StateObject
    private var viewModel = ViewModel()
    
    var body: some View {
        List {
            
        }
        .navigationTitle("Oppskrifter")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    viewModel.showRecipeUrlDialog.toggle()
                }
                .alert("Lim inn lenke til oppskrift", isPresented: $viewModel.showRecipeUrlDialog) {
                    TextField("Lenke", text: $viewModel.recipeUrlText)
                    Button("Avbryt", role: .cancel) {
                        viewModel.recipeUrlText = ""
                    }
                    Button("Legg til") {
                        Task {
                            await viewModel.addRecipe()
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
}
