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
        ZStack {
            BrandBackground()
            
            TabView(selection: $selectedTab) {
                // Sessions
                SessionsListView()
                    .tabItem {
                        Label("Sessions", systemImage: "sparkles.rectangle.stack")
                    }
                    .tag(0)
                
                // Formateurs
                FormateursListView()
                    .tabItem {
                        Label("Formateurs", systemImage: "person.3.sequence.fill")
                    }
                    .tag(1)
                
                // Clients
                ClientsListView()
                    .tabItem {
                        Label("Clients", systemImage: "building.2.crop.circle")
                    }
                    .tag(2)
                
                // Écoles
                EcolesListView()
                    .tabItem {
                        Label("Écoles", systemImage: "graduationcap.fill")
                    }
                    .tag(3)
                
                // Profil
                ProfileView()
                    .tabItem {
                        Label("Profil", systemImage: "person.crop.circle.badge.checkmark")
                    }
                    .tag(4)
            }
            .tint(.brandCyan)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService.shared)
}
