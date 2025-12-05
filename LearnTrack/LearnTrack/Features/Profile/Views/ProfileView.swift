//
//  ProfileView.swift
//  LearnTrack
//
//  Vue du profil utilisateur
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showingLogoutAlert = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var sessionVM = SessionViewModel()
    
    var body: some View {
        NavigationView {
            List {
                LTHeroHeader(title: "Profil", subtitle: authService.currentUser?.email ?? "", systemImage: "person.crop.circle.fill")
                // Section utilisateur
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(LT.ColorToken.primary.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .foregroundColor(LT.ColorToken.primary)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text({
                                if let u = authService.currentUser {
                                    let name = "\(u.prenom) \(u.nom)".trimmingCharacters(in: .whitespaces)
                                    return name.isEmpty ? "Utilisateur" : name
                                }
                                return "Utilisateur"
                            }())
                                .font(.headline)
                        
                            Text(authService.currentUser?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            // Badge rôle
                            Text(authService.userRole == .admin ? "Administrateur" : "Utilisateur")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(authService.userRole == .admin ? LT.ColorToken.accent.opacity(0.2) : LT.ColorToken.primary.opacity(0.2))
                                .foregroundColor(authService.userRole == .admin ? LT.ColorToken.accent : LT.ColorToken.primary)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // KPIs
                Section {
                    HStack(spacing: 12) {
                        LT.Tile(title: "À venir", value: "\(upcomingSessions)", systemImage: "calendar", color: LT.ColorToken.secondary)
                        LT.Tile(title: "Rôle", value: authService.userRole == .admin ? "Admin" : "Utilisateur", systemImage: "star.fill", color: LT.ColorToken.accent)
                    }
                    .listRowInsets(EdgeInsets())
                }

                // Préférences
                Section("Préférences") {
                    Toggle(isOn: $isDarkMode) {
                        Label("Mode sombre", systemImage: "moon.fill")
                    }
                }
                
                // Informations
                Section("À propos") {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link(destination: URL(string: "https://github.com")!) {
                        Label("Code source", systemImage: "link")
                    }
                }
                
                // Compte
                Section {
                    Button(action: {
                        showingLogoutAlert = true
                    }) {
                        Label("Déconnexion", systemImage: "arrow.right.square")
                            .foregroundColor(LT.ColorToken.danger)
                    }
                } header: {
                    Text("Compte")
                } footer: {
                    Text("LearnTrack © 2025\nApplication de gestion de formations")
                        .font(.caption)
                        .foregroundColor(LT.ColorToken.textSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                }
            }
            .navigationTitle("Profil")
            .ltScreen()
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
            .task { await sessionVM.fetchSessions() }
        }
    }
}

extension ProfileView {
    private var upcomingSessions: Int { sessionVM.sessions.filter { $0.date >= Date() }.count }
}

#Preview {
    ProfileView()
        .environmentObject(AuthService.shared)
}
