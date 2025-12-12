//
//  LTTabBar.swift
//  LearnTrack
//
//  TabBar Custom avec support Light/Dark mode
//

import SwiftUI

// MARK: - Tab Item
struct LTTabItem: Identifiable, Equatable {
    let id = UUID()
    let icon: String
    let selectedIcon: String
    
    init(icon: String, selectedIcon: String? = nil) {
        self.icon = icon
        self.selectedIcon = selectedIcon ?? "\(icon).fill"
    }
    
    static func == (lhs: LTTabItem, rhs: LTTabItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - LTTabBar View
struct LTTabBar: View {
    @Binding var selectedIndex: Int
    let items: [LTTabItem]
    
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var namespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                tabButton(index: index, item: item)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(tabBarBackground)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(borderGradient, lineWidth: 1)
        )
        .shadow(color: shadowColor, radius: 20, y: 10)
        .shadow(color: .emerald500.opacity(colorScheme == .dark ? 0.15 : 0.1), radius: 30, y: 15)
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
    }
    
    // MARK: - Tab Button
    private func tabButton(index: Int, item: LTTabItem) -> some View {
        let isSelected = selectedIndex == index
        
        return Button {
            selectTab(index)
        } label: {
            ZStack {
                // Blob indicator
                if isSelected {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.emerald400, .emerald600],
                                center: .center,
                                startRadius: 0,
                                endRadius: 25
                            )
                        )
                        .frame(width: 50, height: 50)
                        .matchedGeometryEffect(id: "blob", in: namespace)
                        .shadow(color: .emerald500.opacity(0.5), radius: 10, y: 2)
                }
                
                // Icon
                Image(systemName: isSelected ? item.selectedIcon : item.icon)
                    .font(.system(size: 22, weight: isSelected ? .bold : .medium))
                    .foregroundColor(iconColor(isSelected: isSelected))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.ltSpringSnappy, value: isSelected)
            }
            .frame(width: 60, height: 50)
            .contentShape(Rectangle())
        }
        .buttonStyle(TabButtonStyle())
    }
    
    // MARK: - Colors (Light/Dark adaptive)
    
    private var tabBarBackground: some View {
        Group {
            if colorScheme == .dark {
                // Dark mode: glass dark
                ZStack {
                    Color(red: 0.08, green: 0.08, blue: 0.1).opacity(0.9)
                    Rectangle().fill(.ultraThinMaterial)
                }
            } else {
                // Light mode: glass light
                ZStack {
                    Color.white.opacity(0.85)
                    Rectangle().fill(.ultraThinMaterial)
                }
            }
        }
    }
    
    private var borderGradient: LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [.white.opacity(0.15), .white.opacity(0.05), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [.black.opacity(0.08), .black.opacity(0.03), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? .black.opacity(0.3) : .black.opacity(0.1)
    }
    
    private func iconColor(isSelected: Bool) -> Color {
        if isSelected {
            return .white
        } else {
            return colorScheme == .dark ? .slate400 : .slate500
        }
    }
    
    // MARK: - Select Tab
    private func selectTab(_ index: Int) {
        guard index != selectedIndex else { return }
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        withAnimation(.ltSpringSnappy) {
            selectedIndex = index
        }
    }
}

// MARK: - Tab Button Style
struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.ltSpringSubtle, value: configuration.isPressed)
    }
}

// MARK: - Main Container (Sans transition de page)
struct LTTabView<Content: View>: View {
    @Binding var selectedIndex: Int
    let items: [LTTabItem]
    let content: (Int) -> Content
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            Color.ltBackground
                .ignoresSafeArea()
            
            // Page content - PAS d'animation entre pages
            content(selectedIndex)
            
            // TabBar
            LTTabBar(selectedIndex: $selectedIndex, items: items)
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Preview
#Preview("Light Mode") {
    struct PreviewWrapper: View {
        @State private var tab = 0
        
        var body: some View {
            LTTabView(
                selectedIndex: $tab,
                items: [
                    LTTabItem(icon: "calendar"),
                    LTTabItem(icon: "person.2"),
                    LTTabItem(icon: "building.2"),
                    LTTabItem(icon: "graduationcap"),
                    LTTabItem(icon: "gearshape")
                ]
            ) { index in
                VStack {
                    Text("Page \(index + 1)")
                        .font(.ltH1)
                        .foregroundColor(.ltText)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    return PreviewWrapper()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    struct PreviewWrapper: View {
        @State private var tab = 0
        
        var body: some View {
            LTTabView(
                selectedIndex: $tab,
                items: [
                    LTTabItem(icon: "calendar"),
                    LTTabItem(icon: "person.2"),
                    LTTabItem(icon: "building.2"),
                    LTTabItem(icon: "graduationcap"),
                    LTTabItem(icon: "gearshape")
                ]
            ) { index in
                VStack {
                    Text("Page \(index + 1)")
                        .font(.ltH1)
                        .foregroundColor(.ltText)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    return PreviewWrapper()
        .preferredColorScheme(.dark)
}
