import Assets
import SwiftData
import SwiftUI

struct RecipeCard: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @State
    private var showOptions: Bool = false
    
    @State
    private var showDeleteAlert: Bool = false
    
    @State
    private var editRecipeId: PersistentIdentifier? = nil
    
    let recipe: Recipe
    let onTap: (Recipe) -> Void
    
    var body: some View {
        HStack(spacing: Assets.Margins.sm) {
            Button {
                onTap(recipe)
            } label: {
                Card(recipe: recipe)
                    .overlay(alignment: .topTrailing) {
                        Button {
                            withAnimation(.snappy) {
                                showOptions.toggle()
                            }
                        } label: {
                            Image(systemName: showOptions ? "xmark" : "ellipsis")
                                .frame(width: 20, height: 20)
                                .padding(Assets.Margins.xs)
                                .contentTransition(
                                    .symbolEffect(
                                        .replace.magic(
                                            fallback: .downUp.byLayer
                                        ),
                                        options: .nonRepeating
                                    )
                                )
                        }
                        .buttonStyle(.glass)
                        .clipShape(.circle)
                        .padding(.trailing, Assets.Margins.sm)
                        .padding(.top, Assets.Margins.sm)
                    }
                    .padding(.leading, Assets.Margins.lg)
                    .padding(.trailing, showOptions ? 0 : Assets.Margins.lg)
            }
            
            if showOptions {
                VStack {
                    ShareLink(item: recipe.url, preview: SharePreview(recipe.title, image: recipe.image)) {
                        Image(systemName: "square.and.arrow.up")
                            .frame(width: 20, height: 20)
                            .padding(Assets.Margins.xs)
                    }
                    .buttonStyle(.glass)
                    .clipShape(.circle)
                    
                    Spacer()
                    
                    Button {
                        editRecipeId = recipe.id
                    } label: {
                        Image(systemName: "pencil")
                            .frame(width: 20, height: 20)
                            .padding(Assets.Margins.xs)
                    }
                    .buttonStyle(.glass)
                    .clipShape(.circle)
                    .sheet(item: $editRecipeId) { id in
                        RecipeEditScreen(id: id, in: modelContext.container)
                    }
                    
                    Spacer()
                    
                    Button {
                        showDeleteAlert.toggle()
                    } label: {
                        Image(systemName: "trash")
                            .frame(width: 20, height: 20)
                            .padding(Assets.Margins.xs)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Assets.Colors.delete)
                    .clipShape(.circle)
                    .alert(
                        "Slett oppskriften?",
                        isPresented: $showDeleteAlert
                    ) {
                        Button("Slett", systemImage: "trash", role: .destructive) {
                            try! RecipeRepository.delete(recipe, in: modelContext)
                        }
                    }
                }
                .padding(.trailing, Assets.Margins.sm)
            }
        }
    }
}

fileprivate struct Card: View {
    @Environment(\.colorScheme)
    private var colorScheme
    
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
                .lineLimit(2)
                .multilineTextAlignment(.leading)
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
    }
}
