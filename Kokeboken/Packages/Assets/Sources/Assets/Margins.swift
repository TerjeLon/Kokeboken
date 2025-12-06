import SwiftUI

/// A collection of margin and spacing values for consistent layout
public struct AppMargins {
    // MARK: - Small Spacing
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    
    // MARK: - Medium Spacing
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 20
    public static let xxl: CGFloat = 24
    
    // MARK: - Large Spacing
    public static let xxxl: CGFloat = 32
    public static let huge: CGFloat = 40
    public static let massive: CGFloat = 48
    
    // MARK: - Edge Insets
    public static let edgeInsetsSmall = EdgeInsets(top: sm, leading: sm, bottom: sm, trailing: sm)
    public static let edgeInsetsMedium = EdgeInsets(top: md, leading: md, bottom: md, trailing: md)
    public static let edgeInsetsLarge = EdgeInsets(top: lg, leading: lg, bottom: lg, trailing: lg)
    public static let edgeInsetsXLarge = EdgeInsets(top: xl, leading: xl, bottom: xl, trailing: xl)
    
    private init() {}
}

