//
//  MainTabView.swift
//  LearnTrack
//
//  Navigation principale avec TabBar
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard
            DashboardView()
                .tabItem { Label("Accueil", systemImage: "house.fill") }
                .tag(0)
            // Sessions
            SessionsListView()
                .tabItem {
                    Label("Sessions", systemImage: "calendar")
                }
                .tag(1)
            
            // Formateurs
            FormateursListView()
                .tabItem {
                    Label("Formateurs", systemImage: "person.2.fill")
                }
                .tag(2)
            
            // Clients
            ClientsListView()
                .tabItem {
                    Label("Clients", systemImage: "building.2.fill")
                }
                .tag(3)
            
            // Écoles
            EcolesListView()
                .tabItem {
                    Label("Écoles", systemImage: "graduationcap.fill")
                }
                .tag(4)
            
            // Profil
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.circle.fill")
                }
                .tag(5)
        }
        .accentColor(LT.ColorToken.primary)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService.shared)
}
