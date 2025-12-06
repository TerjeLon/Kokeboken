import SwiftUI

extension Recipe {
    var image: Image {
        guard
            let imageData,
            let uiImage = UIImage(data: imageData)
        else {
            return Image(uiImage: UIImage())
        }
        
        return Image(uiImage: uiImage)
    }
}
