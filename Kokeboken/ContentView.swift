import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @StateObject
    var navigationCoordinator = NavigationCoordinator()

    var body: some View {
        NavigationStack(path: $navigationCoordinator.path) {
            RecipeListScreen()
        }
        .environmentObject(navigationCoordinator)
    }
}

#Preview {
    let modelContainer = mockedModelContainer()
    
    ContentView()
        .modelContainer(modelContainer)
        .task {
            await Recipe.injectMockedList(into: modelContainer.mainContext)
        }
}
