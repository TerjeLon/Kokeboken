import Foundation
import SwiftData

/// A recipe model representing a cooking recipe with associated metadata.
@Model
final class Recipe {
    /// A unique identifier for the recipe.
    @Attribute(.unique) var id: UUID
    
    /// The title or name of the recipe.
    var title: String
    
    /// The URL where the recipe can be found or accessed.
    var url: URL
    
    /// Optional image data associated with the recipe
    var imageData: Data?
    
    /// The tags associated with this recipe.
    @Relationship(deleteRule: .nullify, inverse: \Tag.recipes)
    var tags: [Tag]?
    
    /// Initializes a new recipe instance.
    /// - Parameters:
    ///   - title: The title or name of the recipe.
    ///   - url: The URL where the recipe can be found or accessed.
    ///   - imageData: Optional image data associated with the recipe.
    ///   - tags: An array of tags to associate with the recipe. Defaults to an empty array.
    init(
        title: String,
        url: URL,
        imageData: Data? = nil,
        tags: [Tag] = []
    ) {
        self.id = UUID()
        self.title = title
        self.url = url
        self.imageData = imageData
        self.tags = tags
    }
}

