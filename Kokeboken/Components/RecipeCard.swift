import Assets
import SwiftUI

struct RecipeCard: View {
    @Environment(\.colorScheme)
    private var colorScheme
    
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 0) {
            recipe.image
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 100)
                .clipped()
            
            Text(recipe.title)
                .padding(.horizontal, Assets.Margins.sm)
                .padding(.vertical, Assets.Margins.md)
                .foregroundStyle(Assets.Colors.textPrimary)
                .font(.headline)
        }
        .background(Assets.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: Assets.Radiuses.xxl))
        .transition(.offset(x: 0, y: -20).combined(with: .opacity))
        .overlay {
            RoundedRectangle(cornerRadius: Assets.Radiuses.xxl)
                .strokeBorder(Assets.Colors.border, lineWidth: 1.5)
        }
        .shadow(
            color: colorScheme == .dark ? .black.opacity(0.2) : .black.opacity(0.15),
            radius: 10,
            x: 0,
            y: colorScheme == .dark ? 3 : 3
        )
        .padding(.horizontal, Assets.Margins.lg)
    }
}
