//
//  AuthService.swift
//  LearnTrack
//
//  Service d'authentification via API REST
//

import Foundation
import Combine
import Supabase

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var isAuthenticated = false
    @Published var currentUser: APIUser?
    @Published var userRole: UserRole = .user
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
        if let userJSON = KeychainManager.shared.get("auth_user"),
           let data = userJSON.data(using: .utf8),
           let user = try? JSONDecoder().decode(APIUser.self, from: data) {
            self.currentUser = user
            self.userRole = UserRole(rawValue: user.role) ?? .user
            self.isAuthenticated = true
        } else {
            self.isAuthenticated = false
            self.currentUser = nil
            self.userRole = .user
        }
    }
    
    // Connexion
    func signIn(email: String, password: String) async throws {
        let resp = try await APIService.shared.login(email: email, password: password)
        guard resp.success, let user = resp.user else {
            throw APIError.unauthorized
        }
        
        // Persist user
        let data = try JSONEncoder().encode(user)
        _ = KeychainManager.shared.save(String(decoding: data, as: UTF8.self), forKey: "auth_user")
        
        await MainActor.run {
            self.currentUser = user
            self.userRole = UserRole(rawValue: user.role) ?? .user
            self.isAuthenticated = true
        }
    }
    
    // Déconnexion
    func signOut() async throws {
        await MainActor.run {
            self.isAuthenticated = false
            self.currentUser = nil
            self.userRole = .user
        }
        KeychainManager.shared.delete("auth_user")
    }
    
    // Réinitialisation du mot de passe (via Supabase pour conserver la fonctionnalité)
    func resetPassword(email: String) async throws {
        let client = SupabaseManager.shared.client!
        try await client.auth.resetPasswordForEmail(email)
    }
}
