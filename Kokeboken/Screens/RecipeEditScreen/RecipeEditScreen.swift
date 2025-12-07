import Assets
import SwiftData
import SwiftUI

struct RecipeEditScreen: View {
    @Environment(\.dismiss)
    var dismiss
    
    @Bindable
    var recipe: Recipe
    
    var modelContext: ModelContext

    init(id: PersistentIdentifier, in container: ModelContainer) {
        modelContext = ModelContext(container)
        modelContext.autosaveEnabled = false
        recipe = modelContext.model(for: id) as! Recipe
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("", text: $recipe.title, axis: .vertical)
                        .padding(.vertical, Assets.Margins.sm)
                } header: {
                    Text("Tittel")
                        .foregroundStyle(Assets.Colors.textSecondary)
                }
                .listRowBackground(Assets.Colors.surface)
                .listRowInsets(.vertical, 0)
            }
            .scrollContentBackground(.hidden)
            .background(Assets.Colors.background)
            .navigationTitle("Rediger oppskrift")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        try? modelContext.save()
                        dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}
