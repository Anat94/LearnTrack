//
//  APIError.swift
//  LearnTrack
//
//  Gestion des erreurs API
//

import Foundation

enum APIError: LocalizedError {
    case invalidResponse
    case invalidData
    case networkError(Error)
    case decodingError(Error)
    case authenticationRequired
    case unauthorized
    case notFound
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Réponse du serveur invalide"
        case .invalidData:
            return "Données invalides"
        case .networkError(let error):
            return "Erreur réseau: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Erreur de décodage: \(error.localizedDescription)"
        case .authenticationRequired:
            return "Authentification requise"
        case .unauthorized:
            return "Accès non autorisé"
        case .notFound:
            return "Ressource introuvable"
        case .serverError(let message):
            return "Erreur serveur: \(message)"
        }
    }
}
