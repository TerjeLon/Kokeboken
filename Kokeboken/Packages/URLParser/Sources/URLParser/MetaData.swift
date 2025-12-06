import Foundation

/// Metadata extracted from a URL's webpage
@available(iOS 17.0, *)
public struct MetaData {
    /// The title of the recipe or webpage
    public let title: String?
    
    /// The URL that was parsed
    public let url: URL
    
    /// The image URL from the webpage metadata
    public let image: URL?
    
    public init(title: String?, url: URL, image: URL?) {
        self.title = title
        self.url = url
        self.image = image
    }
}

