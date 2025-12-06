import SwiftUI

/// A collection of corner radius values for consistent rounded corners
public struct AppRadiuses {
    // MARK: - Small Radius
    public static let xs: CGFloat = 2
    public static let sm: CGFloat = 4
    public static let md: CGFloat = 6
    
    // MARK: - Medium Radius
    public static let lg: CGFloat = 8
    public static let xl: CGFloat = 12
    public static let xxl: CGFloat = 16
    
    // MARK: - Large Radius
    public static let xxxl: CGFloat = 20
    public static let huge: CGFloat = 24
    public static let massive: CGFloat = 32
    
    // MARK: - Circular
    public static let circular: CGFloat = .infinity
    
    private init() {}
}

