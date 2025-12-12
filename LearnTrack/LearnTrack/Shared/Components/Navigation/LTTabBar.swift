//
//  LTTabBar.swift
//  LearnTrack
//
//  TabBar flottante Liquid Glass - Design Emerald Premium
//

import SwiftUI

// MARK: - Tab Item
struct LTTabItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let selectedIcon: String
    
    init(title: String, icon: String, selectedIcon: String? = nil) {
        self.title = title
        self.icon = icon
        self.selectedIcon = selectedIcon ?? "\(icon).fill"
    }
}

// MARK: - TabBar Style
enum LTTabBarStyle {
    case floating   // Flottante avec blur - effet liquid glass
    case docked     // Attachée au bas
    case minimal    // Minimaliste sans fond
}

// MARK: - LTTabBar View
struct LTTabBar: View {
    @Binding var selectedIndex: Int
    let items: [LTTabItem]
    var style: LTTabBarStyle = .floating
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                tabButton(for: index)
            }
        }
        .padding(.horizontal, style == .floating ? LTSpacing.md : 0)
        .padding(.vertical, LTSpacing.sm)
        .background(tabBarBackground)
        .clipShape(RoundedRectangle(cornerRadius: style == .floating ? LTRadius.xxxl : 0))
        .overlay(
            style == .floating ?
                RoundedRectangle(cornerRadius: LTRadius.xxxl)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                : nil
        )
        .shadow(color: .black.opacity(0.15), radius: style == .floating ? 20 : 0, y: -5)
        .padding(.horizontal, style == .floating ? LTSpacing.lg : 0)
        .padding(.bottom, style == .floating ? LTSpacing.lg : 0)
    }
    
    private func tabButton(for index: Int) -> some View {
        Button(action: {
            withAnimation(.ltSpringBouncy) {
                selectedIndex = index
            }
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }) {
            VStack(spacing: LTSpacing.xxs) {
                ZStack {
                    // Glow indicator for selected
                    if selectedIndex == index {
                        Circle()
                            .fill(Color.emerald500.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .blur(radius: 8)
                    }
                    
                    Image(systemName: selectedIndex == index ? items[index].selectedIcon : items[index].icon)
                        .font(.system(size: LTIconSize.lg, weight: selectedIndex == index ? .semibold : .regular))
                        .foregroundColor(selectedIndex == index ? .emerald500 : .ltTextTertiary)
                }
                .frame(height: 32)
                
                Text(items[index].title)
                    .font(.ltSmallMedium)
                    .foregroundColor(selectedIndex == index ? .emerald500 : .ltTextTertiary)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var tabBarBackground: some View {
        switch style {
        case .floating:
            // Liquid glass effect
            ZStack {
                // Blur
                Color.ltCard.opacity(0.9)
                
                // Glass overlay
                LinearGradient(
                    colors: [.white.opacity(0.1), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .background(.ultraThinMaterial)
        case .docked:
            Color.ltCard
        case .minimal:
            Color.clear
        }
    }
}

// MARK: - LTTabView Container
struct LTTabView<Content: View>: View {
    @Binding var selectedIndex: Int
    let items: [LTTabItem]
    var style: LTTabBarStyle = .floating
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content()
            
            LTTabBar(selectedIndex: $selectedIndex, items: items, style: style)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedTab = 0
        
        let tabs = [
            LTTabItem(title: "Sessions", icon: "calendar"),
            LTTabItem(title: "Formateurs", icon: "person.2"),
            LTTabItem(title: "Clients", icon: "building.2"),
            LTTabItem(title: "Écoles", icon: "graduationcap"),
            LTTabItem(title: "Profil", icon: "person.circle")
        ]
        
        var body: some View {
            LTTabView(selectedIndex: $selectedTab, items: tabs, style: .floating) {
                ZStack {
                    Color.ltBackground.ignoresSafeArea()
                    Text("Tab \(selectedTab + 1)")
                        .font(.ltH1)
                }
            }
        }
    }
    
    return PreviewWrapper()
}
