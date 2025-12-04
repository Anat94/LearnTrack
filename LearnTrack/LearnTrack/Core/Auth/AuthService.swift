//
//  AuthService.swift
//  LearnTrack
//
//  Service d'authentification avec Supabase
//

import Foundation
import Supabase
import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var userRole: UserRole = .user
    
    private let supabase = SupabaseManager.shared.client!
    private var cancellables = Set<AnyCancellable>()
    
    enum UserRole: String, Codable {
        case admin
        case user
    }
    
    private init() {
        checkAuthStatus()
    }
    
    // Vérifier le statut d'authentification au démarrage
    func checkAuthStatus() {
        Task {
            do {
                let session = try await supabase.auth.session
                await MainActor.run {
                    self.isAuthenticated = true
                    self.loadUserProfile()
                }
            } catch {
                await MainActor.run {
                    self.isAuthenticated = false
                    self.currentUser = nil
                }
            }
        }
    }
    
    // Connexion
    func signIn(email: String, password: String) async throws {
        let session = try await supabase.auth.signIn(
            email: email,
            password: password
        )
        
        await MainActor.run {
            self.isAuthenticated = true
            self.loadUserProfile()
        }
    }
    
    // Déconnexion
    func signOut() async throws {
        try await supabase.auth.signOut()
        
        await MainActor.run {
            self.isAuthenticated = false
            self.currentUser = nil
            self.userRole = .user
        }
        
        KeychainManager.shared.deleteAll()
    }
    
    // Charger le profil utilisateur
    private func loadUserProfile() {
        Task {
            do {
                let user = try await supabase.auth.user()
                
                // Récupérer le rôle depuis la table users
                let response: [User] = try await supabase
                    .from("users")
                    .select()
                    .eq("supabase_user_id", value: user.id.uuidString)
                    .execute()
                    .value
                
                await MainActor.run {
                    if let userProfile = response.first {
                        self.currentUser = userProfile
                        self.userRole = UserRole(rawValue: userProfile.role) ?? .user
                    }
                }
            } catch {
                print("Erreur chargement profil: \(error)")
            }
        }
    }
    
    // Réinitialisation du mot de passe
    func resetPassword(email: String) async throws {
        try await supabase.auth.resetPasswordForEmail(email)
    }
}

// Modèle User
struct User: Codable, Identifiable {
    let id: Int64
    let username: String
    let email: String
    let role: String
    let supabaseUserId: String
    let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case role
        case supabaseUserId = "supabase_user_id"
        case isActive = "is_active"
    }
}
