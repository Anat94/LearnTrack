//
//  MainTabView.swift
//  LearnTrack
//
//  Navigation principale style Winamax
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        ZStack {
            WinamaxBackground()
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                // Sessions
                SessionsListView()
                    .tabItem {
                        Label("Sessions", systemImage: "calendar")
                    }
                    .tag(0)
                
                // Formateurs
                FormateursListView()
                    .tabItem {
                        Label("Formateurs", systemImage: "person.2.fill")
                    }
                    .tag(1)
                
                // Clients
                ClientsListView()
                    .tabItem {
                        Label("Clients", systemImage: "building.2.fill")
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
                        Label("Profil", systemImage: "person.circle.fill")
                    }
                    .tag(4)
            }
            .tint(theme.primaryGreen)
            .onAppear {
                // Personnalisation de la TabBar
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = theme == .dark ? 
                    UIColor(red: 0.12, green: 0.12, blue: 0.16, alpha: 0.95) :
                    UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 0.95)
                
                appearance.shadowColor = UIColor(theme.shadowColor)
                appearance.shadowImage = UIImage()
                
                // Couleur des items non sélectionnés
                appearance.stackedLayoutAppearance.normal.iconColor = UIColor(theme.textSecondary)
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                    .foregroundColor: UIColor(theme.textSecondary),
                    .font: UIFont.systemFont(ofSize: 11, weight: .medium)
                ]
                
                // Couleur des items sélectionnés
                appearance.stackedLayoutAppearance.selected.iconColor = UIColor(theme.primaryGreen)
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                    .foregroundColor: UIColor(theme.primaryGreen),
                    .font: UIFont.systemFont(ofSize: 11, weight: .bold)
                ]
                
                UITabBar.appearance().standardAppearance = appearance
                if #available(iOS 15.0, *) {
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
