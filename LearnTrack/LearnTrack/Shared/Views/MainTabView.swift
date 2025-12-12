//
//  MainTabView.swift
//  LearnTrack
//
//  Navigation principale avec TabBar custom Emerald
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    private let tabItems = [
        LTTabItem(icon: "calendar", activeIcon: "calendar.circle.fill", title: "Sessions"),
        LTTabItem(icon: "person.2", activeIcon: "person.2.fill", title: "Formateurs"),
        LTTabItem(icon: "building.2", activeIcon: "building.2.fill", title: "Clients"),
        LTTabItem(icon: "graduationcap", activeIcon: "graduationcap.fill", title: "Écoles"),
        LTTabItem(icon: "person.circle", activeIcon: "person.circle.fill", title: "Profil")
    ]
    
    var body: some View {
        LTTabView(
            selectedIndex: $selectedTab,
            items: tabItems,
            tabBarStyle: .floating
        ) { index in
            Group {
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
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService.shared)
}
