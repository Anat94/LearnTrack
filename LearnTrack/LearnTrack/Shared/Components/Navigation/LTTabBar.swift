//
//  LTTabBar.swift
//  LearnTrack
//
//  TabBar ultra-custom Liquid Glass - Zéro style iOS
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

// MARK: - LTTabBar View
struct LTTabBar: View {
    @Binding var selectedIndex: Int
    let items: [LTTabItem]
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                tabButton(for: index)
            }
        }
        .padding(.horizontal, LTSpacing.sm)
        .padding(.vertical, LTSpacing.sm)
        .background(tabBarBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(
                    LinearGradient(
                        colors: [.emerald500.opacity(0.3), .emerald600.opacity(0.1), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: .black.opacity(0.25), radius: 20, y: 8)
        .shadow(color: .emerald500.opacity(0.15), radius: 30, y: 10)
        .padding(.horizontal, LTSpacing.xl)
        .padding(.bottom, LTSpacing.md)
    }
    
    private func tabButton(for index: Int) -> some View {
        let isSelected = selectedIndex == index
        
        return Button(action: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedIndex = index
            }
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }) {
            VStack(spacing: 4) {
                ZStack {
                    // Background pill for selected
                    if isSelected {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.emerald500, .emerald600],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 32)
                            .matchedGeometryEffect(id: "tab_indicator", in: animation)
                            .shadow(color: .emerald500.opacity(0.5), radius: 8, y: 2)
                    }
                    
                    // Icon
                    Image(systemName: isSelected ? items[index].selectedIcon : items[index].icon)
                        .font(.system(size: isSelected ? 18 : 20, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? .white : .slate400)
                        .scaleEffect(isSelected ? 1.0 : 0.9)
                }
                .frame(height: 32)
                
                // Label
                Text(items[index].title)
                    .font(.system(size: 10, weight: isSelected ? .bold : .medium, design: .rounded))
                    .foregroundColor(isSelected ? .emerald400 : .slate500)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var tabBarBackground: some View {
        ZStack {
            // Base dark
            Color.slate900.opacity(0.95)
            
            // Glass effect overlay
            LinearGradient(
                colors: [.white.opacity(0.08), .white.opacity(0.02)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Subtle pattern
            Color.emerald900.opacity(0.1)
        }
        .background(.ultraThinMaterial)
    }
}

// MARK: - LTTabView Container with Page Transitions
struct LTTabView<Content: View>: View {
    @Binding var selectedIndex: Int
    let items: [LTTabItem]
    @ViewBuilder let content: () -> Content
    
    @State private var previousIndex = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content with page transition
            content()
                .transition(pageTransition)
                .id(selectedIndex) // Force view refresh for animation
                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: selectedIndex)
            
            // Custom TabBar
            LTTabBar(selectedIndex: $selectedIndex, items: items)
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: selectedIndex) { oldValue, _ in
            previousIndex = oldValue
        }
    }
    
    private var pageTransition: AnyTransition {
        let direction = selectedIndex > previousIndex
        return .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.92)).combined(with: .offset(x: direction ? 30 : -30)),
            removal: .opacity.combined(with: .scale(scale: 1.05)).combined(with: .offset(x: direction ? -30 : 30))
        )
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
            LTTabView(selectedIndex: $selectedTab, items: tabs) {
                ZStack {
                    Color.ltBackground.ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Text(tabs[selectedTab].title)
                            .font(.ltH1)
                            .foregroundColor(.ltText)
                        
                        Text("Tab \(selectedTab + 1)")
                            .font(.ltCaption)
                            .foregroundColor(.ltTextSecondary)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    return PreviewWrapper()
}
