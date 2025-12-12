//
//  LTTabBar.swift
//  LearnTrack
//
//  TabBar custom flottante - Zéro iOS natif
//

import SwiftUI

// MARK: - Tab Item Model
struct LTTabItem: Identifiable {
    let id = UUID()
    let icon: String
    let activeIcon: String
    let title: String
    
    init(icon: String, activeIcon: String? = nil, title: String) {
        self.icon = icon
        self.activeIcon = activeIcon ?? icon
        self.title = title
    }
}

// MARK: - LTTabBar View
struct LTTabBar: View {
    @Binding var selectedIndex: Int
    let items: [LTTabItem]
    let style: TabBarStyle
    
    enum TabBarStyle {
        case floating    // Flottante avec blur
        case docked      // Attachée au bas
        case minimal     // Minimaliste sans fond
    }
    
    @Namespace private var animation
    
    init(
        selectedIndex: Binding<Int>,
        items: [LTTabItem],
        style: TabBarStyle = .floating
    ) {
        self._selectedIndex = selectedIndex
        self.items = items
        self.style = style
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                TabBarButton(
                    item: item,
                    isSelected: selectedIndex == index,
                    animation: animation,
                    action: {
                        withAnimation(.ltSpringSnappy) {
                            selectedIndex = index
                        }
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }
                )
            }
        }
        .padding(.horizontal, style == .floating ? LTSpacing.md : 0)
        .padding(.vertical, LTSpacing.sm)
        .background(backgroundView)
        .if(style == .floating) { view in
            view
                .clipShape(Capsule())
                .ltElevatedShadow()
                .padding(.horizontal, LTSpacing.xl)
                .padding(.bottom, LTSpacing.md)
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .floating:
            ZStack {
                // Blur background
                Capsule()
                    .fill(.ultraThinMaterial)
                
                // Subtle border
                Capsule()
                    .stroke(Color.ltBorderSubtle, lineWidth: 1)
            }
        case .docked:
            Rectangle()
                .fill(Color.ltCard)
                .overlay(
                    Rectangle()
                        .fill(Color.ltBorder)
                        .frame(height: 1),
                    alignment: .top
                )
        case .minimal:
            Color.clear
        }
    }
}

// MARK: - Tab Bar Button
private struct TabBarButton: View {
    let item: LTTabItem
    let isSelected: Bool
    let animation: Namespace.ID
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: LTSpacing.xxs) {
                ZStack {
                    // Background indicator
                    if isSelected {
                        Circle()
                            .fill(Color.emerald500.opacity(0.15))
                            .frame(width: 48, height: 48)
                            .matchedGeometryEffect(id: "tab_bg", in: animation)
                    }
                    
                    // Icon
                    Image(systemName: isSelected ? item.activeIcon : item.icon)
                        .font(.system(size: LTIconSize.lg, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? .emerald500 : .ltTextTertiary)
                        .scaleEffect(isPressed ? 0.85 : 1.0)
                        .animation(.ltSpringBouncy, value: isPressed)
                }
                .frame(width: 48, height: 48)
                
                // Label
                Text(item.title)
                    .font(.ltSmallMedium)
                    .foregroundColor(isSelected ? .emerald500 : .ltTextTertiary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Main Tab View Container
struct LTTabView<Content: View>: View {
    @Binding var selectedIndex: Int
    let items: [LTTabItem]
    let tabBarStyle: LTTabBar.TabBarStyle
    @ViewBuilder let content: (Int) -> Content
    
    init(
        selectedIndex: Binding<Int>,
        items: [LTTabItem],
        tabBarStyle: LTTabBar.TabBarStyle = .floating,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self._selectedIndex = selectedIndex
        self.items = items
        self.tabBarStyle = tabBarStyle
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            content(selectedIndex)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Tab Bar
            LTTabBar(
                selectedIndex: $selectedIndex,
                items: items,
                style: tabBarStyle
            )
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Preview
#Preview("Tab Bar Styles") {
    VStack(spacing: 40) {
        Text("Floating (Default)")
            .font(.ltH3)
        
        LTTabBar(
            selectedIndex: .constant(0),
            items: [
                LTTabItem(icon: "calendar", activeIcon: "calendar.circle.fill", title: "Sessions"),
                LTTabItem(icon: "person.2", activeIcon: "person.2.fill", title: "Formateurs"),
                LTTabItem(icon: "building.2", activeIcon: "building.2.fill", title: "Clients"),
                LTTabItem(icon: "graduationcap", activeIcon: "graduationcap.fill", title: "Écoles"),
                LTTabItem(icon: "person.circle", activeIcon: "person.circle.fill", title: "Profil")
            ],
            style: .floating
        )
        
        Text("Docked")
            .font(.ltH3)
        
        LTTabBar(
            selectedIndex: .constant(2),
            items: [
                LTTabItem(icon: "calendar", activeIcon: "calendar.circle.fill", title: "Sessions"),
                LTTabItem(icon: "person.2", activeIcon: "person.2.fill", title: "Formateurs"),
                LTTabItem(icon: "building.2", activeIcon: "building.2.fill", title: "Clients")
            ],
            style: .docked
        )
        
        Spacer()
    }
    .padding(.top, 40)
    .background(Color.ltBackground)
}

#Preview("Full Tab View") {
    struct PreviewWrapper: View {
        @State private var selectedTab = 0
        
        var body: some View {
            LTTabView(
                selectedIndex: $selectedTab,
                items: [
                    LTTabItem(icon: "calendar", activeIcon: "calendar.circle.fill", title: "Sessions"),
                    LTTabItem(icon: "person.2", activeIcon: "person.2.fill", title: "Formateurs"),
                    LTTabItem(icon: "building.2", activeIcon: "building.2.fill", title: "Clients"),
                    LTTabItem(icon: "graduationcap", activeIcon: "graduationcap.fill", title: "Écoles"),
                    LTTabItem(icon: "person.circle", activeIcon: "person.circle.fill", title: "Profil")
                ]
            ) { index in
                VStack {
                    Spacer()
                    Text("Tab \(index + 1)")
                        .font(.ltDisplay)
                        .foregroundColor(.emerald500)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.ltBackground)
            }
        }
    }
    
    return PreviewWrapper()
}
