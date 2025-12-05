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
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    
    init() {
        // Garder Supabase pour reset password
        SupabaseManager.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                MainTabView()
                    .environmentObject(authService)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            } else if !hasOnboarded {
                WelcomeView()
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            } else {
                LoginView()
                    .environmentObject(authService)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            }
        }
    }
}
