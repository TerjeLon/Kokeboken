import SwiftUI
import SwiftData
import SafariServices
import Foundation

struct RecipeReaderScreen: View {
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        SafariView(url: recipe.url, colorScheme: colorScheme, onDismiss: {
            dismiss()
        })
        .edgesIgnoringSafeArea(.all)
        .toolbarVisibility(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    let colorScheme: ColorScheme
    let onDismiss: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onDismiss: onDismiss)
    }
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = context.coordinator
        updateColors(for: safariViewController)
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Update colors when color scheme changes
        updateColors(for: uiViewController)
    }
    
    private func updateColors(for safariViewController: SFSafariViewController) {
        safariViewController.overrideUserInterfaceStyle = colorScheme == .dark ? .dark : .light
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

