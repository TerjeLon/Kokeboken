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
        
        @Published
        var addRecipeSuccess: Bool = false
        
        var cancellable: AnyCancellable?
        
        init() {
            observeDialogShown()
        }
        
        func addRecipe(into context: ModelContext) async {
            guard let url = URL(string: recipeUrlText) else {
                return
            }
            
            withAnimation(.snappy) {
                isAddingRecipe = true
            }
            
            do {
                let metadata = try await URLParser.parse(url: url)
                let recipe = Recipe.from(metadata)
                
                // TODO: Use AI to strip away stuff that is not related to recipe name
                
                try RecipeRepository.insert(recipe, into: context)
            } catch {
                // TODO: Handle errors
            }
            
            await MainActor.run {
                withAnimation(.snappy(duration: 0.3)) {
                    addRecipeSuccess = true
                } completion: { [weak self] in
                    Task {
                        try? await Task.sleep(for: .seconds(1))
                        
                        await MainActor.run {
                            withAnimation(.snappy(duration: 0.3)) {
                                self?.isAddingRecipe = false
                                self?.addRecipeSuccess = false
                                
                                // TODO: Scroll to added recipe
                            }
                        }
                    }
                }
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
