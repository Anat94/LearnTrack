//
//  MockAPIService.swift
//  LearnTrackTests
//
//  Mock service for unit testing ViewModels
//

import Foundation
@testable import LearnTrack

class MockAPIService: APIServiceProtocol {
    
    // MARK: - Simulation Properties
    var shouldFail = false
    var mockError: Error = APIError.invalidResponse
    
    // Data storage for simulation
    var sessions: [APISession] = []
    var formateurs: [APIFormateur] = []
    var clients: [APIClient] = []
    var ecoles: [APIEcole] = []
    var users: [APIUser] = []
    
    // MARK: - Health
    func checkHealth() async throws -> HealthResponse {
        if shouldFail { throw mockError }
        return HealthResponse(status: "ok")
    }
    
    func checkDatabaseHealth() async throws -> DatabaseHealthResponse {
        if shouldFail { throw mockError }
        return DatabaseHealthResponse(status: "ok", database: "connected")
    }
    
    // MARK: - Auth
    func login(email: String, password: String) async throws -> AuthResponse {
        if shouldFail { throw mockError }
        return AuthResponse(success: true, message: "Login successful", user: users.first)
    }
    
    func register(email: String, password: String, nom: String, prenom: String) async throws -> AuthResponse {
        if shouldFail { throw mockError }
        let newUser = APIUser(id: Int.random(in: 100...999), email: email, nom: nom, prenom: prenom, role: "user", actif: true)
        return AuthResponse(success: true, message: "Register successful", user: newUser)
    }
    
    // MARK: - Clients
    func getClients() async throws -> [APIClient] {
        if shouldFail { throw mockError }
        return clients
    }
    
    func getClient(id: Int) async throws -> APIClient {
        if shouldFail { throw mockError }
        guard let client = clients.first(where: { $0.id == id }) else { throw APIError.notFound }
        return client
    }
    
    func createClient(_ client: APIClientCreate) async throws -> APIClient {
        if shouldFail { throw mockError }
        let newClient = APIClient(
            id: Int.random(in: 100...999),
            nom: client.nom,
            email: client.email,
            telephone: client.telephone,
            adresse: client.adresse,
            ville: client.ville,
            codePostal: client.codePostal,
            siret: client.siret,
            contactNom: client.contactNom,
            contactEmail: client.contactEmail,
            contactTelephone: client.contactTelephone,
            notes: client.notes,
            actif: true
        )
        clients.append(newClient)
        return newClient
    }
    
    func updateClient(id: Int, _ client: APIClientUpdate) async throws -> APIClient {
        if shouldFail { throw mockError }
        guard let index = clients.firstIndex(where: { $0.id == id }) else { throw APIError.notFound }
        
        var updated = clients[index]
        // Simulate partial update (simplified)
        // Note: Real implementation would verify which fields are not nil
        if let nom = client.nom { updated = APIClient(id: id, nom: nom, email: updated.email, telephone: updated.telephone, adresse: updated.adresse, ville: updated.ville, codePostal: updated.codePostal, siret: updated.siret, contactNom: updated.contactNom, contactEmail: updated.contactEmail, contactTelephone: updated.contactTelephone, notes: updated.notes, actif: updated.actif) }
        
        clients[index] = updated
        return updated
    }
    
    func deleteClient(id: Int) async throws {
        if shouldFail { throw mockError }
        clients.removeAll { $0.id == id }
    }
    
    func getClientSessions(clientId: Int) async throws -> [APISession] {
        if shouldFail { throw mockError }
        return sessions.filter { $0.clientId == clientId }
    }
    
    // MARK: - Ecoles
    func getEcoles() async throws -> [APIEcole] {
        if shouldFail { throw mockError }
        return ecoles
    }
    
    func getEcole(id: Int) async throws -> APIEcole {
        if shouldFail { throw mockError }
        guard let ecole = ecoles.first(where: { $0.id == id }) else { throw APIError.notFound }
        return ecole
    }
    
    func createEcole(_ ecole: APIEcoleCreate) async throws -> APIEcole {
        if shouldFail { throw mockError }
        let newEcole = APIEcole(
            id: Int.random(in: 100...999),
            nom: ecole.nom,
            adresse: ecole.adresse,
            ville: ecole.ville,
            codePostal: ecole.codePostal,
            telephone: ecole.telephone,
            email: ecole.email,
            responsableNom: ecole.responsableNom,
            capacite: ecole.capacite,
            notes: ecole.notes,
            actif: true
        )
        ecoles.append(newEcole)
        return newEcole
    }
    
    func updateEcole(id: Int, _ ecole: APIEcoleUpdate) async throws -> APIEcole {
        if shouldFail { throw mockError }
        guard let index = ecoles.firstIndex(where: { $0.id == id }) else { throw APIError.notFound }
        return ecoles[index] // Simplified
    }
    
    func deleteEcole(id: Int) async throws {
        if shouldFail { throw mockError }
        ecoles.removeAll { $0.id == id }
    }
    
    func getEcoleSessions(ecoleId: Int) async throws -> [APISession] {
        if shouldFail { throw mockError }
        return sessions.filter { $0.ecoleId == ecoleId }
    }
    
    // MARK: - Formateurs
    func getFormateurs() async throws -> [APIFormateur] {
        if shouldFail { throw mockError }
        return formateurs
    }
    
    func getFormateur(id: Int) async throws -> APIFormateur {
        if shouldFail { throw mockError }
        guard let formateur = formateurs.first(where: { $0.id == id }) else { throw APIError.notFound }
        return formateur
    }
    
    func createFormateur(_ formateur: APIFormateurCreate) async throws -> APIFormateur {
        if shouldFail { throw mockError }
        let newFormateur = APIFormateur(
            id: Int.random(in: 100...999),
            nom: formateur.nom,
            prenom: formateur.prenom,
            email: formateur.email,
            telephone: formateur.telephone,
            specialites: formateur.specialites,
            tarifJournalier: formateur.tarifJournalier,
            adresse: formateur.adresse,
            ville: formateur.ville,
            codePostal: formateur.codePostal,
            notes: formateur.notes,
            actif: true
        )
        formateurs.append(newFormateur)
        return newFormateur
    }
    
    func updateFormateur(id: Int, _ formateur: APIFormateurUpdate) async throws -> APIFormateur {
        if shouldFail { throw mockError }
        guard let index = formateurs.firstIndex(where: { $0.id == id }) else { throw APIError.notFound }
        return formateurs[index]
    }
    
    func deleteFormateur(id: Int) async throws {
        if shouldFail { throw mockError }
        formateurs.removeAll { $0.id == id }
    }
    
    func getFormateurSessions(formateurId: Int) async throws -> [APISession] {
        if shouldFail { throw mockError }
        return sessions.filter { $0.formateurId == formateurId }
    }
    
    // MARK: - Sessions
    func getSessions() async throws -> [APISession] {
        if shouldFail { throw mockError }
        return sessions
    }
    
    func getSession(id: Int) async throws -> APISession {
        if shouldFail { throw mockError }
        guard let session = sessions.first(where: { $0.id == id }) else { throw APIError.notFound }
        return session
    }
    
    func createSession(_ session: APISessionCreate) async throws -> APISession {
        if shouldFail { throw mockError }
        let newSession = APISession(
            id: Int.random(in: 100...999),
            titre: session.titre,
            description: session.description,
            dateDebut: session.dateDebut,
            dateFin: session.dateFin,
            heureDebut: session.heureDebut,
            heureFin: session.heureFin,
            clientId: session.clientId,
            ecoleId: session.ecoleId,
            formateurId: session.formateurId,
            nbParticipants: session.nbParticipants,
            statut: session.statut ?? "PLANIFIEE",
            prix: session.prix,
            notes: session.notes
        )
        sessions.append(newSession)
        return newSession
    }
    
    func updateSession(id: Int, _ session: APISessionUpdate) async throws -> APISession {
        if shouldFail { throw mockError }
        guard let index = sessions.firstIndex(where: { $0.id == id }) else { throw APIError.notFound }
        return sessions[index]
    }
    
    func deleteSession(id: Int) async throws {
        if shouldFail { throw mockError }
        sessions.removeAll { $0.id == id }
    }
    
    // MARK: - Users
    func getUsers() async throws -> [APIUser] {
        if shouldFail { throw mockError }
        return users
    }
    
    func getUser(id: Int) async throws -> APIUser {
        if shouldFail { throw mockError }
        guard let user = users.first(where: { $0.id == id }) else { throw APIError.notFound }
        return user
    }
    
    func createUser(_ user: APIUserCreate) async throws -> APIUser {
        if shouldFail { throw mockError }
        let newUser = APIUser(id: Int.random(in: 100...999), email: user.email, nom: user.nom, prenom: user.prenom, role: user.role ?? "user", actif: true)
        users.append(newUser)
        return newUser
    }
    
    func updateUser(id: Int, _ user: APIUserUpdate) async throws -> APIUser {
        if shouldFail { throw mockError }
        guard let index = users.firstIndex(where: { $0.id == id }) else { throw APIError.notFound }
        return users[index]
    }
    
    func deleteUser(id: Int) async throws {
        if shouldFail { throw mockError }
        users.removeAll { $0.id == id }
    }
}
