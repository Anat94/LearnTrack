//
//  ProfileView.swift
//  LearnTrack
//
//  Vue du profil utilisateur - Design Emerald Premium
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.colorScheme) var colorScheme
    @State private var showingLogoutAlert = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var userName: String {
        if let u = authService.currentUser {
            let name = "\(u.prenom) \(u.nom)".trimmingCharacters(in: .whitespaces)
            return name.isEmpty ? "Utilisateur" : name
        }
        return "Utilisateur"
    }
    
    var userInitials: String {
        if let u = authService.currentUser {
            let first = u.prenom.first.map { String($0) } ?? ""
            let last = u.nom.first.map { String($0) } ?? ""
            return (first + last).uppercased()
        }
        return "U"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: LTSpacing.lg) {
                        // Header avec avatar
                        headerCard
                        
                        // Préférences
                        preferencesSection
                        
                        // À propos
                        aboutSection
                        
                        // Déconnexion
                        logoutButton
                        
                        // Footer
                        footerSection
                    }
                    .padding(.horizontal, LTSpacing.lg)
                    .padding(.top, LTSpacing.lg)
                    .padding(.bottom, 120) // Espace pour la TabBar
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
    
    // MARK: - Header Card
    private var headerCard: some View {
        LTCard(variant: .accent) {
            VStack(spacing: LTSpacing.lg) {
                // Avatar avec bordure gradient
                LTAvatar(
                    initials: userInitials,
                    size: .xl,
                    color: .emerald500,
                    showGradientBorder: true
                )
                .shadow(color: .emerald500.opacity(0.3), radius: 16, y: 8)
                
                VStack(spacing: LTSpacing.sm) {
                    Text(userName)
                        .font(.ltH2)
                        .foregroundColor(.ltText)
                    
                    Text(authService.currentUser?.email ?? "")
                        .font(.ltCaption)
                        .foregroundColor(.ltTextSecondary)
                    
                    // Badge rôle
                    LTBadge(
                        text: authService.userRole == .admin ? "Administrateur" : "Utilisateur",
                        icon: authService.userRole == .admin ? "star.fill" : "person.fill",
                        color: authService.userRole == .admin ? .warning : .emerald500,
                        isPill: true
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, LTSpacing.lg)
        }
    }
    
    // MARK: - Preferences Section
    private var preferencesSection: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.lg) {
                Text("Préférences")
                    .font(.ltH4)
                    .foregroundColor(.ltText)
                
                // Toggle Dark Mode
                HStack {
                    ZStack {
                        Circle()
                            .fill(isDarkMode ? Color.slate800 : Color.warning.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .font(.system(size: LTIconSize.md))
                            .foregroundColor(isDarkMode ? .emerald400 : .warning)
                    }
                    
                    VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                        Text("Mode sombre")
                            .font(.ltBodySemibold)
                            .foregroundColor(.ltText)
                        Text(isDarkMode ? "Activé" : "Désactivé")
                            .font(.ltCaption)
                            .foregroundColor(.ltTextSecondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $isDarkMode)
                        .tint(.emerald500)
                        .labelsHidden()
                }
                .animation(.ltSpringSmooth, value: isDarkMode)
            }
        }
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.lg) {
                Text("À propos")
                    .font(.ltH4)
                    .foregroundColor(.ltText)
                
                // Version
                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(.emerald500)
                    
                    Text("Version")
                        .font(.ltBody)
                        .foregroundColor(.ltText)
                    
                    Spacer()
                    
                    Text("1.0.0")
                        .font(.ltCaptionMedium)
                        .foregroundColor(.ltTextSecondary)
                        .padding(.horizontal, LTSpacing.sm)
                        .padding(.vertical, LTSpacing.xxs)
                        .background(Color.ltBackgroundSecondary)
                        .clipShape(Capsule())
                }
                
                Divider()
                    .background(Color.ltBorder)
                
                // Code source
                Link(destination: URL(string: "https://github.com")!) {
                    HStack {
                        Image(systemName: "link")
                            .font(.system(size: LTIconSize.md))
                            .foregroundColor(.emerald500)
                        
                        Text("Code source")
                            .font(.ltBody)
                            .foregroundColor(.emerald500)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: LTIconSize.sm))
                            .foregroundColor(.emerald500)
                    }
                }
            }
        }
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        LTButton(
            "Déconnexion",
            variant: .destructive,
            icon: "rectangle.portrait.and.arrow.right",
            isFullWidth: true
        ) {
            showingLogoutAlert = true
        }
    }
    
    // MARK: - Footer
    private var footerSection: some View {
        VStack(spacing: LTSpacing.md) {
            // Logo
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.emerald400, .emerald600],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: "book.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .shadow(color: .emerald500.opacity(0.3), radius: 12, y: 6)
            
            VStack(spacing: LTSpacing.xs) {
                Text("LearnTrack © 2025")
                    .font(.ltCaptionMedium)
                    .foregroundColor(.ltTextSecondary)
                
                Text("Application de gestion de formations")
                    .font(.ltSmall)
                    .foregroundColor(.ltTextTertiary)
            }
        }
        .padding(.top, LTSpacing.xl)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
