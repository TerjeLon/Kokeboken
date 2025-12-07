import Combine
import SwiftData
import SwiftUI
import UIKit
import URLParser

extension RecipeListScreen {
    final class ViewModel: ObservableObject {
        @Published
        var showRecipeUrlDialog: Bool = false
        
        @Published
        var recipeUrlText: String = ""
        
        @Published
        var query: String = ""
        
        @Published
        var isAddingRecipe: Bool = false
        
        var cancellable: AnyCancellable?
        
        init() {
            observeDialogShown()
        }
        
        func addRecipe(into context: ModelContext) async {
            do {
                guard let url = URL(string: recipeUrlText) else {
                    return
                }
                
                withAnimation(.snappy) {
                    isAddingRecipe = true
                }
                
                let metadata = try await URLParser.parse(url: url)
                let recipe = Recipe.from(metadata)
                
                if recipe.title.isEmpty {
                    // TODO: Show dialog to name the recipe
                } else {
                    // TODO: Use AI to strip away stuff that is not related to recipe name
                }
                
                try RecipeRepository.insert(recipe, into: context)
            } catch {
                // TODO: Handle errors
            }
            
            withAnimation(.snappy) {
                isAddingRecipe = false
            }
        }
        
        private func observeDialogShown() {
            cancellable = $showRecipeUrlDialog.sink { shown in
                if shown {
                    self.populateRecipeUrlFromPasteboard()
                }
            }
        }
        
        private func populateRecipeUrlFromPasteboard() {
            guard let pasteboardUrl = UIPasteboard.general.url else {
                return
            }
            
            recipeUrlText = pasteboardUrl.absoluteString
        }
    }
}
