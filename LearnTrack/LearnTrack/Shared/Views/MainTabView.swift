//
//  MainTabView.swift
//  LearnTrack
//
//  Navigation principale avec TabBar Custom et animations
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    // Définition des tabs avec icônes custom
    private let tabs = [
        LTTabItem(title: "Sessions", icon: "calendar", selectedIcon: "calendar.badge.clock"),
        LTTabItem(title: "Formateurs", icon: "person.2", selectedIcon: "person.2.fill"),
        LTTabItem(title: "Clients", icon: "building.2", selectedIcon: "building.2.fill"),
        LTTabItem(title: "Écoles", icon: "graduationcap", selectedIcon: "graduationcap.fill"),
        LTTabItem(title: "Profil", icon: "person.circle", selectedIcon: "person.circle.fill")
    ]
    
    var body: some View {
        LTTabView(selectedIndex: $selectedTab, items: tabs) {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                // Page content with entrance animation
                pageContent
            }
        }
        .ltToasts()
    }
    
    @ViewBuilder
    private var pageContent: some View {
        switch selectedTab {
        case 0:
            SessionsListView()
                .pageEntranceAnimation()
        case 1:
            FormateursListView()
                .pageEntranceAnimation()
        case 2:
            ClientsListView()
                .pageEntranceAnimation()
        case 3:
            EcolesListView()
                .pageEntranceAnimation()
        case 4:
            ProfileView()
                .pageEntranceAnimation()
        default:
            SessionsListView()
                .pageEntranceAnimation()
        }
    }
}

// MARK: - Page Entrance Animation Modifier
struct PageEntranceAnimation: ViewModifier {
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.95)
            .offset(y: isVisible ? 0 : 10)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    isVisible = true
                }
            }
            .onDisappear {
                isVisible = false
            }
    }
}

extension View {
    func pageEntranceAnimation() -> some View {
        modifier(PageEntranceAnimation())
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
