import Combine
import SwiftUI

final class NavigationCoordinator: ObservableObject {
    @Published
    var path = NavigationPath()
}
