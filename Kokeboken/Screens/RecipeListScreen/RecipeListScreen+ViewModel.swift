import Combine
import UIKit

extension RecipeListScreen {
    final class ViewModel: ObservableObject {
        @Published
        var showRecipeUrlDialog: Bool = false
        
        @Published
        var recipeUrlText: String = ""
        
        init() {
            observeDialogShown()
        }
        
        private func observeDialogShown() {
            $showRecipeUrlDialog.sink { shown in
                if shown {
                    populateRecipeUrlFromPasteboard()
                }
            }
        }
        
        private func populateRecipeUrlFromPasteboard() {
            let pasteboard = UIPasteboard.general
            guard let pasteboardString = pasteboard.string,
                  !pasteboardString.isEmpty else {
                return
            }
            
            // Check if the pasteboard content is a valid URL
            if let url = URL(string: pasteboardString),
               url.scheme != nil,
               (url.scheme == "http" || url.scheme == "https") {
                recipeUrlText = pasteboardString
            }
        }
    }
}
