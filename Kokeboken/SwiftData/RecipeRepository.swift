import Foundation
import SwiftData

final class RecipeRepository {
    static func insert(_ recipe: Recipe, into context: ModelContext) {
        context.insert(recipe)
    }
}
