import Combine
import UIKit
import URLParser

extension RecipeListScreen {
    final class ViewModel: ObservableObject {
        @Published
        var showRecipeUrlDialog: Bool = false
        
        @Published
        var recipeUrlText: String = ""
        
        var cancellable: AnyCancellable?
        
        init() {
            observeDialogShown()
        }
        
        func addRecipe() async {
            do {
                guard let url = URL(string: recipeUrlText) else {
                    return
                }
                
                let metadata = try await URLParser.parse(url: url)
                
            } catch {
                // TODO: Handle errors
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
