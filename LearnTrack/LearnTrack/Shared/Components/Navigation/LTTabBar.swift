//
//  LTTabBar.swift
//  LearnTrack
//
//  TabBar Révolutionnaire - Zéro iOS, 100% Custom
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

// MARK: - Blob TabBar
struct LTTabBar: View {
    @Binding var selectedIndex: Int
    let items: [LTTabItem]
    let onTabChange: ((Int, Int) -> Void)?
    
    @State private var localSelection: Int = 0
    @Namespace private var namespace
    
    init(selectedIndex: Binding<Int>, items: [LTTabItem], onTabChange: ((Int, Int) -> Void)? = nil) {
        self._selectedIndex = selectedIndex
        self.items = items
        self.onTabChange = onTabChange
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                tabButton(index: index, item: item)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(glassBackground)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.2),
                            .white.opacity(0.05),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
        .shadow(color: .emerald500.opacity(0.2), radius: 40, y: 15)
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
        .onAppear {
            localSelection = selectedIndex
        }
    }
    
    // MARK: - Tab Button
    private func tabButton(index: Int, item: LTTabItem) -> some View {
        let isSelected = localSelection == index
        
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
                        .shadow(color: .emerald500.opacity(0.6), radius: 12, y: 2)
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                }
                
                // Icon
                Image(systemName: isSelected ? item.selectedIcon : item.icon)
                    .font(.system(size: 22, weight: isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? .white : .slate400)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
            }
            .frame(width: 60, height: 50)
            .contentShape(Rectangle())
        }
        .buttonStyle(TabButtonStyle())
    }
    
    // MARK: - Glass Background
    private var glassBackground: some View {
        ZStack {
            // Ultra dark base
            Color(red: 0.05, green: 0.05, blue: 0.08)
                .opacity(0.85)
            
            // Material blur
            Rectangle()
                .fill(.ultraThinMaterial)
            
            // Subtle gradient overlay
            LinearGradient(
                colors: [
                    .white.opacity(0.08),
                    .clear,
                    .emerald900.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    // MARK: - Select Tab
    private func selectTab(_ index: Int) {
        guard index != localSelection else { return }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        let oldIndex = localSelection
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            localSelection = index
            selectedIndex = index
        }
        
        onTabChange?(oldIndex, index)
    }
}

// MARK: - Tab Button Style (No highlight)
struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Main Container with Page Transitions
struct LTTabView<Content: View>: View {
    @Binding var selectedIndex: Int
    let items: [LTTabItem]
    let content: (Int) -> Content
    
    @State private var previousIndex: Int = 0
    @State private var isAnimating = false
    @State private var direction: TransitionDirection = .forward
    
    enum TransitionDirection {
        case forward, backward
    }
    
    init(selectedIndex: Binding<Int>, items: [LTTabItem], @ViewBuilder content: @escaping (Int) -> Content) {
        self._selectedIndex = selectedIndex
        self.items = items
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            Color.ltBackground
                .ignoresSafeArea()
            
            // Page content with transition
            ZStack {
                content(selectedIndex)
                    .transition(pageTransition)
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedIndex)
            
            // TabBar
            LTTabBar(
                selectedIndex: $selectedIndex,
                items: items,
                onTabChange: { old, new in
                    direction = new > old ? .forward : .backward
                    previousIndex = old
                }
            )
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private var pageTransition: AnyTransition {
        .asymmetric(
            insertion: .opacity
                .combined(with: .scale(scale: direction == .forward ? 0.95 : 1.05))
                .combined(with: .offset(x: direction == .forward ? 50 : -50)),
            removal: .opacity
                .combined(with: .scale(scale: direction == .forward ? 1.05 : 0.95))
                .combined(with: .offset(x: direction == .forward ? -50 : 50))
        )
    }
}

// MARK: - Preview
#Preview("TabBar Only") {
    ZStack {
        Color.slate950.ignoresSafeArea()
        
        VStack {
            Spacer()
            LTTabBar(
                selectedIndex: .constant(0),
                items: [
                    LTTabItem(icon: "calendar"),
                    LTTabItem(icon: "person.2"),
                    LTTabItem(icon: "building.2"),
                    LTTabItem(icon: "graduationcap"),
                    LTTabItem(icon: "person.circle")
                ]
            )
        }
    }
}

#Preview("Full TabView") {
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
                    LTTabItem(icon: "person.circle")
                ]
            ) { index in
                VStack(spacing: 20) {
                    Text("Page \(index + 1)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.ltText)
                    
                    Text("Swipe ou tap pour naviguer")
                        .font(.ltCaption)
                        .foregroundColor(.ltTextSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    return PreviewWrapper()
        .preferredColorScheme(.dark)
}
