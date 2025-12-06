import Combine
import SwiftUI

final class NavigationCoordinator: ObservableObject {
    @Published
    var path = NavigationPath()
    
    func push(_ destination: any Hashable) {
        path.append(destination)
    }
}
