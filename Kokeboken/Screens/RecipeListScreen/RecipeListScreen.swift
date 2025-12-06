import Assets
import SwiftData
import SwiftUI

struct RecipeListScreen: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Query(animation: .snappy)
    private var recipes: [Recipe]
    
    @StateObject
    private var viewModel = ViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(recipes) { recipe in
                    VStack(spacing: 0) {
                        recipe.image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 100)
                            .clipped()
                        
                        Text(recipe.title)
                            .padding(Assets.Margins.sm)
                            .foregroundStyle(Assets.Colors.textPrimary)
                            .font(.headline)
                    }
                    .background(Assets.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: Assets.Radiuses.xxl))
                    .transition(.offset(x: 0, y: -20).combined(with: .opacity))
                    .overlay {
                        RoundedRectangle(cornerRadius: Assets.Radiuses.xxl)
                            .strokeBorder(Assets.Colors.border, lineWidth: 1.5)
                    }
                    .shadow(
                        color: colorScheme == .dark ? .black.opacity(0.2) : .black.opacity(0.15),
                        radius: 10,
                        x: 0,
                        y: colorScheme == .dark ? 3 : 3
                    )
                    .padding(.horizontal, Assets.Margins.lg)
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

#if DEBUG
#Preview {
    let mockedModelContainer = mockedModelContainer()
    
    NavigationStack {
        RecipeListScreen()
    }
    .modelContainer(mockedModelContainer)
    .task {
        await Recipe.injectMockedList(into: mockedModelContainer.mainContext)
    }
}
#endif
