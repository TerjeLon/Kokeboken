import Assets
import SwiftUI

struct RecipeCard: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @EnvironmentObject
    private var navigationCoordinator: NavigationCoordinator
    
    @State
    private var showOptions: Bool = false
    
    @State
    private var showDeleteAlert: Bool = false
    
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: Assets.Margins.sm) {
            Button {
                navigationCoordinator.push(recipe)
            } label: {
                Card(recipe: recipe)
                    .overlay(alignment: .topTrailing) {
                        if !showOptions {
                            Button {
                                withAnimation(.snappy) {
                                    showOptions.toggle()
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .frame(width: 20, height: 20)
                                    .padding(Assets.Margins.xs)
                            }
                            .buttonStyle(.glass)
                            .clipShape(.circle)
                            .padding(.trailing, Assets.Margins.sm)
                            .padding(.top, Assets.Margins.sm)
                        }
                    }
                    .padding(.leading, Assets.Margins.lg)
                    .padding(.trailing, showOptions ? 0 : Assets.Margins.lg)
            }
            
            if showOptions {
                VStack {
                    Button {
                        withAnimation(.snappy) {
                            showOptions.toggle()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .frame(width: 20, height: 20)
                            .padding(Assets.Margins.xs)
                    }
                    .buttonStyle(.glass)
                    .clipShape(.circle)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "pencil")
                            .frame(width: 20, height: 20)
                            .padding(Assets.Margins.xs)
                    }
                    .buttonStyle(.glass)
                    .clipShape(.circle)
                    
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
