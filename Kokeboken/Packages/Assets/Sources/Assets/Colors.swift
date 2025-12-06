import SwiftUI

/// A collection of color assets for the application
public struct AppColors {
    // MARK: - Primary Colors
    /// Primary blue-gray color (#4e6398)
    public static let primary = Color(red: 0.306, green: 0.388, blue: 0.596)
    
    // MARK: - Background Colors
    /// Light pink/peach background color (#fff0f3)
    public static let background = Color(red: 1.0, green: 0.941, blue: 0.953)
    /// Light pink surface color (#F0E1E4)
    public static let surface = Color(red: 0.941, green: 0.882, blue: 0.894)
    

    // MARK: - Text Colors
    /// Dark text color (#000103)
    public static let textPrimary = Color(red: 0.0, green: 0.004, blue: 0.012)
    /// Secondary text color - lighter gray for less prominent text
    public static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.4)
    
    private init() {}
}

