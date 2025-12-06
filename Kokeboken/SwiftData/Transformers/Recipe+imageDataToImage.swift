import SwiftUI

extension Recipe {
    var image: Image {
        return Image(uiImage: UIImage(data: imageData!)!)
    }
}
