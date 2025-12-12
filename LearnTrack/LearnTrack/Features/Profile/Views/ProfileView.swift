//
//  ProfileView.swift
//  LearnTrack
//
//  Vue du profil utilisateur style Winamax
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.colorScheme) var colorScheme
    @State private var showingLogoutAlert = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var userName: String {
        if let u = authService.currentUser {
            let name = "\(u.prenom) \(u.nom)".trimmingCharacters(in: .whitespaces)
            return name.isEmpty ? "Utilisateur" : name
        }
        return "Utilisateur"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                WinamaxBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // En-tête utilisateur
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [theme.primaryGreen, theme.primaryGreen.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .shadow(color: theme.primaryGreen.opacity(0.4), radius: 20, y: 10)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 45, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 8) {
                                Text(userName)
                                    .font(.winamaxTitle())
                                    .foregroundColor(theme.textPrimary)
                                
                                Text(authService.currentUser?.email ?? "")
                                    .font(.winamaxCaption())
                                    .foregroundColor(theme.textSecondary)
                                
                                // Badge rôle
                                WinamaxBadge(
                                    text: authService.userRole == .admin ? "Administrateur" : "Utilisateur",
                                    color: authService.userRole == .admin ? theme.accentOrange : theme.primaryGreen
                                )
                            }
                        }
                        .padding(.top, 20)
                        .winamaxCard()
                        .padding(.horizontal, 20)
                        
                        // Préférences
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Préférences")
                                .font(.winamaxHeadline())
                                .foregroundColor(theme.textPrimary)
                                .padding(.horizontal, 4)
                            
                            Toggle(isOn: $isDarkMode) {
                                HStack(spacing: 12) {
                                    Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                        .foregroundColor(theme.primaryGreen)
                                        .font(.system(size: 18))
                                    
                                    Text("Mode sombre")
                                        .font(.winamaxBody())
                                        .foregroundColor(theme.textPrimary)
                                }
                            }
                            .tint(theme.primaryGreen)
                        }
                        .winamaxCard()
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("À propos")
                                .font(.winamaxHeadline())
                                .foregroundColor(theme.textPrimary)
                                .padding(.horizontal, 4)
                            
                            HStack {
                                Label("Version", systemImage: "info.circle")
                                    .font(.winamaxBody())
                                    .foregroundColor(theme.textPrimary)
                                
                                Spacer()
                                
                                Text("1.0.0")
                                    .font(.winamaxCaption())
                                    .foregroundColor(theme.textSecondary)
                            }
                            
                            Divider()
                                .background(theme.borderColor)
                            
                            Link(destination: URL(string: "https://github.com")!) {
                                HStack {
                                    Label("Code source", systemImage: "link")
                                        .font(.winamaxBody())
                                        .foregroundColor(theme.primaryGreen)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.up.right.square")
                                        .foregroundColor(theme.primaryGreen)
                                }
                            }
                        }
                        .winamaxCard()
                        .padding(.horizontal, 20)
                        
                        // Déconnexion
                        Button(action: {
                            showingLogoutAlert = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.square.fill")
                                    .font(.system(size: 18))
                                Text("Déconnexion")
                                    .font(.winamaxBody())
                            }
                            .foregroundColor(.white)
                        }
                        .buttonStyle(WinamaxDangerButton())
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 16) {
                            AppLogo(size: 60)
                            
                            VStack(spacing: 8) {
                                Text("LearnTrack © 2025")
                                    .font(.winamaxCaption())
                                    .foregroundColor(theme.textSecondary)
                                
                                Text("Application de gestion de formations")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(theme.textSecondary.opacity(0.7))
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .alert("Déconnexion", isPresented: $showingLogoutAlert) {
                Button("Annuler", role: .cancel) { }
                Button("Déconnexion", role: .destructive) {
                    Task {
                        try? await authService.signOut()
                    }
                }
            } message: {
                Text("Êtes-vous sûr de vouloir vous déconnecter ?")
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
