import Foundation
import URLParser

extension Recipe {
    static func from(_ metaData: MetaData) -> Recipe {
        var imageData: Data? = nil
        
        if let imageURL = metaData.image {
            imageData = fetchImageData(from: imageURL)
        }
        
        return Recipe(
            title: metaData.title ?? "",
            url: metaData.url,
            imageData: imageData,
            tags: []
        )
    }
    
    private static func fetchImageData(from url: URL) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Data? = nil
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            result = data
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .now() + 10)
        return result
    }
}
