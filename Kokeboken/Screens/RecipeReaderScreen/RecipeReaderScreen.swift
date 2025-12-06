import SwiftUI
import SwiftData
import SafariServices
import Foundation

struct RecipeReaderScreen: View {
    let recipe: Recipe
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        SafariView(url: recipe.url, onDismiss: {
            dismiss()
        })
        .edgesIgnoringSafeArea(.all)
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    let onDismiss: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onDismiss: onDismiss)
    }
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = context.coordinator
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No update needed
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let onDismiss: () -> Void
        
        init(onDismiss: @escaping () -> Void) {
            self.onDismiss = onDismiss
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            onDismiss()
        }
    }
}
