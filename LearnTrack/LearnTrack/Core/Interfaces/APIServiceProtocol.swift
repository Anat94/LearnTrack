//
//  APIServiceProtocol.swift
//  LearnTrack
//
//  Interface pour le service API afin de permettre le mock pour les tests unitaires.
//

import Foundation

protocol APIServiceProtocol {
    // Health
    func checkHealth() async throws -> HealthResponse
    func checkDatabaseHealth() async throws -> DatabaseHealthResponse
    
    // Auth
    func login(email: String, password: String) async throws -> AuthResponse
    func register(email: String, password: String, nom: String, prenom: String) async throws -> AuthResponse
    
    // Clients
    func getClients() async throws -> [APIClient]
    func getClient(id: Int) async throws -> APIClient
    func createClient(_ client: APIClientCreate) async throws -> APIClient
    func updateClient(id: Int, _ client: APIClientUpdate) async throws -> APIClient
    func deleteClient(id: Int) async throws
    func getClientSessions(clientId: Int) async throws -> [APISession]
    
    // Ecoles
    func getEcoles() async throws -> [APIEcole]
    func getEcole(id: Int) async throws -> APIEcole
    func createEcole(_ ecole: APIEcoleCreate) async throws -> APIEcole
    func updateEcole(id: Int, _ ecole: APIEcoleUpdate) async throws -> APIEcole
    func deleteEcole(id: Int) async throws
    func getEcoleSessions(ecoleId: Int) async throws -> [APISession]
    
    // Formateurs
    func getFormateurs() async throws -> [APIFormateur]
    func getFormateur(id: Int) async throws -> APIFormateur
    func createFormateur(_ formateur: APIFormateurCreate) async throws -> APIFormateur
    func updateFormateur(id: Int, _ formateur: APIFormateurUpdate) async throws -> APIFormateur
    func deleteFormateur(id: Int) async throws
    func getFormateurSessions(formateurId: Int) async throws -> [APISession]
    
    // Sessions
    func getSessions() async throws -> [APISession]
    func getSession(id: Int) async throws -> APISession
    func createSession(_ session: APISessionCreate) async throws -> APISession
    func updateSession(id: Int, _ session: APISessionUpdate) async throws -> APISession
    func deleteSession(id: Int) async throws
    
    // Users
    func getUsers() async throws -> [APIUser]
    func getUser(id: Int) async throws -> APIUser
    func createUser(_ user: APIUserCreate) async throws -> APIUser
    func updateUser(id: Int, _ user: APIUserUpdate) async throws -> APIUser
    func deleteUser(id: Int) async throws
}
