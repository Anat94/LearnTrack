//
//  MainTabView.swift
//  LearnTrack
//
//  Navigation principale avec TabBar révolutionnaire
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    // Tabs - icônes seulement, zéro labels
    private let tabs = [
        LTTabItem(icon: "calendar", selectedIcon: "calendar.badge.clock"),
        LTTabItem(icon: "person.2", selectedIcon: "person.2.fill"),
        LTTabItem(icon: "building.2", selectedIcon: "building.2.fill"),
        LTTabItem(icon: "graduationcap", selectedIcon: "graduationcap.fill"),
        LTTabItem(icon: "gearshape", selectedIcon: "gearshape.fill")
    ]
    
    var body: some View {
        LTTabView(selectedIndex: $selectedTab, items: tabs) { index in
            pageForIndex(index)
        }
        .ltToasts()
    }
    
    @ViewBuilder
    private func pageForIndex(_ index: Int) -> some View {
        switch index {
        case 0:
            SessionsListView()
        case 1:
            FormateursListView()
        case 2:
            ClientsListView()
        case 3:
            EcolesListView()
        case 4:
            ProfileView()
        default:
            SessionsListView()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
