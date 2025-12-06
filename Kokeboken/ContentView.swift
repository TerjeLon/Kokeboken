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
    ContentView()
        .modelContainer(mockedModelContainer())
}
