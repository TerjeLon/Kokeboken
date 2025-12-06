import SwiftData

func mockedModelContainer() -> ModelContainer {
    let schema = Schema([
        Recipe.self,
        Tag.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    return try! ModelContainer(for: schema, configurations: [modelConfiguration])
}

