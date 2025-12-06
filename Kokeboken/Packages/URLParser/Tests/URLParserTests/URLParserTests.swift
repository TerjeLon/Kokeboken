import Testing
import Foundation
@testable import URLParser

struct URLParserTests {
    @Test func odaRecipeUrlExtractsImage() async throws {
        let url = URL(string: "https://oda.com/no/recipes/4256-silje-feiring-rask-fennikelsalat-med-svinekoteletter-og-ris/")!
        let metadata = try await URLParser.parse(url: url)
        
        // Verify that an image URL was extracted
        #expect(metadata.image != nil, "Expected to find an image URL for Oda recipe page")
        
        // Verify the image URL is valid
        if let imageURL = metadata.image {
            #expect(imageURL.absoluteString.count > 0, "Image URL should not be empty")
        }
    }
}

