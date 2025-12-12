//
//  MainTabView.swift
//  LearnTrack
//
//  Navigation principale avec TabBar Liquid Glass Emerald
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    // Définition des tabs
    private let tabs = [
        LTTabItem(title: "Sessions", icon: "calendar"),
        LTTabItem(title: "Formateurs", icon: "person.2"),
        LTTabItem(title: "Clients", icon: "building.2"),
        LTTabItem(title: "Écoles", icon: "graduationcap"),
        LTTabItem(title: "Profil", icon: "person.circle")
    ]
    
    var body: some View {
        LTTabView(selectedIndex: $selectedTab, items: tabs, style: .floating) {
            ZStack {
                // Fond avec gradient subtil
                Color.ltBackground
                    .ignoresSafeArea()
                
                // Contenu selon l'onglet sélectionné
                Group {
                    switch selectedTab {
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
        .ltToasts() // Support des toast notifications
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
