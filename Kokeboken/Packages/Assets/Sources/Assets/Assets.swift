import SwiftUI

/// Main entry point for the Assets package
/// Provides access to all design system assets including colors, margins, and radiuses
@available(iOS 17.0, *)
public enum Assets {
    /// Color assets for the application
    public typealias Colors = AppColors
    
    /// Margin and spacing values
    public typealias Margins = AppMargins
    
    /// Corner radius values
    public typealias Radiuses = AppRadiuses
}

