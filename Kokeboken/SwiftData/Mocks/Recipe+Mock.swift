#if DEBUG
import Foundation
import SwiftData
import URLParser

extension Recipe {
    static func injectMockedList(into context: ModelContext) async {
        let urls = [
            "https://www.nrk.no/mat/kinesisk-amerikansk-biff-chop-suey-1.16078725"
        ]
        
        for url in urls {
            guard let metaData = try? await URLParser.parse(url: URL(string: url)!) else {
                continue
            }
            
            let recipe = Recipe.from(metaData)
            try? await RecipeRepository.insert(recipe, into: context)
        }
    }
}
#endif
