import Foundation
import SwiftData

final class RecipeRepository {
    static func insert(_ recipe: Recipe, into context: ModelContext) throws {
        context.insert(recipe)
        try context.save()
    }
}
