import SwiftUI
import UIKit

/// Extension to support light/dark mode color variants
extension Color {
    /// Creates a color that adapts to light and dark mode
    /// - Parameters:
    ///   - light: The color to use in light mode (RGB components)
    ///   - dark: The color to use in dark mode (RGB components)
    init(light: (red: Double, green: Double, blue: Double), dark: (red: Double, green: Double, blue: Double)) {
        self.init(uiColor: UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: dark.red, green: dark.green, blue: dark.blue, alpha: 1.0)
            default:
                return UIColor(red: light.red, green: light.green, blue: light.blue, alpha: 1.0)
            }
        })
    }
}

/// A collection of color assets for the application
/// All colors support both light and dark mode
public struct AppColors {
    // MARK: - Primary Colors
    /// Primary blue-gray color
    /// Light mode: #4e6398, Dark mode: #7A8FB8 (softer blue-gray that complements rosy theme)
    public static let primary = Color(
        light: (red: 0.306, green: 0.388, blue: 0.596),
        dark: (red: 0.478, green: 0.561, blue: 0.722)
    )
    
    // MARK: - Background Colors
    /// Background color
    /// Light mode: #fff0f3 (light pink/peach), Dark mode: #3A2528 (deep rosy brown)
    public static let background = Color(
        light: (red: 1.0, green: 0.941, blue: 0.953),
        dark: (red: 0.227, green: 0.145, blue: 0.157)
    )
    
    /// Surface color for cards and elevated elements
    /// Light mode: #F0E1E4 (light pink), Dark mode: #4A3236 (medium rosy)
    public static let surface = Color(
        light: (red: 0.941, green: 0.882, blue: 0.894),
        dark: (red: 0.290, green: 0.196, blue: 0.212)
    )
    

    // MARK: - Text Colors
    /// Primary text color
    /// Light mode: #000103 (very dark), Dark mode: #FFFFFF (white)
    public static let textPrimary = Color(
        light: (red: 0.0, green: 0.004, blue: 0.012),
        dark: (red: 1.0, green: 1.0, blue: 1.0)
    )
    
    /// Secondary text color for less prominent text
    /// Light mode: #666666 (gray), Dark mode: #B0B0B0 (light gray)
    public static let textSecondary = Color(
        light: (red: 0.4, green: 0.4, blue: 0.4),
        dark: (red: 0.690, green: 0.690, blue: 0.690)
    )
    
    private init() {}
}

