import Foundation
import SwiftData

/// A tag model representing a categorization label for recipes.
@Model
final class Tag {
    /// The unique name of the tag.
    @Attribute(.unique)
    var name: String
    
    /// The recipes associated with this tag.
    @Relationship(deleteRule: .nullify)
    var recipes: [Recipe]
    
    /// Initializes a new tag instance.
    /// - Parameter name: The unique name of the tag.
    init(name: String) {
        self.name = name
        self.recipes = []
    }
}

