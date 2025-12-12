//
//  ProfileView.swift
//  LearnTrack
//
//  Vue du profil utilisateur - Design Emerald Premium
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showingLogoutAlert = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: LTSpacing.xl) {
                        // Header with avatar
                        profileHeader
                        
                        // Settings sections
                        VStack(spacing: LTSpacing.md) {
                            preferencesSection
                            aboutSection
                            accountSection
                        }
                        
                        // Footer
                        footerSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, LTSpacing.lg)
                    .padding(.top, LTSpacing.lg)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profil")
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                }
            }
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
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        LTCard(variant: .accent) {
            HStack(spacing: LTSpacing.lg) {
                // Avatar with gradient border
                LTAvatar(
                    initials: userInitials,
                    size: .xl,
                    color: .emerald500,
                    showGradientBorder: true
                )
                
                VStack(alignment: .leading, spacing: LTSpacing.sm) {
                    Text(userName)
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                    
                    Text(authService.currentUser?.email ?? "")
                        .font(.ltCaption)
                        .foregroundColor(.ltTextSecondary)
                    
                    // Role badge
                    LTBadge(
                        text: authService.userRole == .admin ? "Administrateur" : "Utilisateur",
                        icon: authService.userRole == .admin ? "shield.fill" : "person.fill",
                        color: authService.userRole == .admin ? .warning : .emerald500,
                        size: .small
                    )
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Preferences Section
    private var preferencesSection: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                Text("Préférences")
                    .font(.ltH4)
                    .foregroundColor(.ltText)
                
                // Dark mode toggle
                HStack {
                    HStack(spacing: LTSpacing.md) {
                        ZStack {
                            Circle()
                                .fill(Color.slate700)
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "moon.fill")
                                .font(.system(size: LTIconSize.md))
                                .foregroundColor(.warning)
                        }
                        
                        Text("Mode sombre")
                            .font(.ltBodyMedium)
                            .foregroundColor(.ltText)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $isDarkMode)
                        .tint(.emerald500)
                }
            }
        }
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                Text("À propos")
                    .font(.ltH4)
                    .foregroundColor(.ltText)
                
                // Version
                HStack {
                    HStack(spacing: LTSpacing.md) {
                        ZStack {
                            Circle()
                                .fill(Color.info.opacity(0.15))
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: LTIconSize.md))
                                .foregroundColor(.info)
                        }
                        
                        Text("Version")
                            .font(.ltBody)
                            .foregroundColor(.ltText)
                    }
                    
                    Spacer()
                    
                    Text("1.0.0")
                        .font(.ltMono)
                        .foregroundColor(.ltTextSecondary)
                }
                
                Divider()
                
                // Source code link
                Link(destination: URL(string: "https://github.com")!) {
                    HStack {
                        HStack(spacing: LTSpacing.md) {
                            ZStack {
                                Circle()
                                    .fill(Color.slate800)
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: "chevron.left.forwardslash.chevron.right")
                                    .font(.system(size: LTIconSize.sm, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Code source")
                                .font(.ltBody)
                                .foregroundColor(.ltText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: LTIconSize.sm))
                            .foregroundColor(.ltTextTertiary)
                    }
                }
            }
        }
    }
    
    // MARK: - Account Section
    private var accountSection: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                Text("Compte")
                    .font(.ltH4)
                    .foregroundColor(.ltText)
                
                // Logout button
                Button(action: { showingLogoutAlert = true }) {
                    HStack {
                        HStack(spacing: LTSpacing.md) {
                            ZStack {
                                Circle()
                                    .fill(Color.error.opacity(0.15))
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: LTIconSize.md))
                                    .foregroundColor(.error)
                            }
                            
                            Text("Déconnexion")
                                .font(.ltBodyMedium)
                                .foregroundColor(.error)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: LTIconSize.sm))
                            .foregroundColor(.ltTextTertiary)
                    }
                }
            }
        }
    }
    
    // MARK: - Footer
    private var footerSection: some View {
        VStack(spacing: LTSpacing.sm) {
            Image(systemName: "book.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(.emerald500)
            
            Text("LearnTrack © 2025")
                .font(.ltCaption)
                .foregroundColor(.ltTextSecondary)
            
            Text("Application de gestion de formations")
                .font(.ltSmall)
                .foregroundColor(.ltTextTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, LTSpacing.xl)
    }
    
    // MARK: - Helpers
    private var userName: String {
        if let u = authService.currentUser {
            let name = "\(u.prenom) \(u.nom)".trimmingCharacters(in: .whitespaces)
            return name.isEmpty ? "Utilisateur" : name
        }
        return "Utilisateur"
    }
    
    private var userInitials: String {
        if let u = authService.currentUser {
            let first = u.prenom.prefix(1)
            let last = u.nom.prefix(1)
            let initials = "\(first)\(last)"
            return initials.isEmpty ? "U" : initials.uppercased()
        }
        return "U"
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthService.shared)
}
