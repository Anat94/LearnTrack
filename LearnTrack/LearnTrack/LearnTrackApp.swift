//
//  LearnTrackApp.swift
//  LearnTrack
//
//  Created on December 4, 2025.
//

import SwiftUI

@main
struct LearnTrackApp: App {
    @StateObject private var authService = AuthService.shared
    
    init() {
        // Configuration initiale de Supabase
        SupabaseManager.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                MainTabView()
                    .environmentObject(authService)
            } else {
                LoginView()
                    .environmentObject(authService)
            }
        }
    }
}
