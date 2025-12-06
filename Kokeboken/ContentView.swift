import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext)
    private var modelContext

    var body: some View {
        NavigationStack {
            RecipeListScreen()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(mockedModelContainer())
}
